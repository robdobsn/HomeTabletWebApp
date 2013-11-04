class WallTabApp
    constructor: ->
        @tileColours = new TileColours
        @rdHomeServerUrl = "http://192.168.0.97:5000"
        @calendarUrl = @rdHomeServerUrl + "/calendars/api/v1.0/cal"
        @automationServerUrl = @rdHomeServerUrl + "/automation/api/v1.0"
        @tabletConfigUrl = @rdHomeServerUrl + "/tablet/api/v1.0/config"

    go: ->
        # Basic body for DOM
        $("body").append """
            <div id="sqGroupTitles"></div>
            <div id="sqWrapper">
              <div id="sqTileWrapper">
              </div>
            </div>
            """

        # Scrolls back to most important panels on left of display after user idle timeout
        @userIdleCatcher = new UserIdleCatcher(30, @actionOnUserIdle)

        # Manage ui grouping (rooms, action-groups, etc)
        @automationActionGroups = []
        @uiGroupMapping = {}

        # All communication with Vera3 & Indigo now through automation server
        @automationServer = new AutomationServer(@automationServerUrl)
        @automationServer.setReadyCallback(@automationServerReadyCb)

        # Tablet config is based on the IP address of the tablet
        @tabletConfig = new TabletConfig @tabletConfigUrl
        @tabletConfig.setReadyCallback(@configReadyCb)

        # UI container for tiles
        @tileContainer = new TileContainer "#sqTileWrapper", "#sqGroupTitles"
        @tileContainer.clearTiles()

        # Favourites group
        @favouritesGroupIdx = @tileContainer.addGroup "Home"
        @addClock(@favouritesGroupIdx)

        # Calendar group
        @calendarGroupIdx = @tileContainer.addGroup "Calendar"
        @addCalendar(@calendarGroupIdx)

        # Scenes group
        @sceneGroupIdx = @tileContainer.addGroup "Scenes"
        @tileContainer.reDoLayout()

        # Handler for orientation change
        $(window).on 'orientationchange', =>
          @tileContainer.reDoLayout()

        # And resize event
        $(window).on 'resize', =>
          @tileContainer.reDoLayout()

        # Make initial requests for action (scene) data and config data and repeat requests at intervals
        @requestActionAndConfigData()
        setInterval =>
            @requestActionAndConfigData()
        , 36000000

    requestActionAndConfigData: ->
        @automationServer.getActionGroups()
        @tabletConfig.initTabletConfig()
    
    addClock: (groupIdx) ->
        tile = new Clock @tileColours.getNextColour(), 3, null, "", "clock"
        @tileContainer.addTileToGroup(groupIdx, tile)

    addCalendar: (groupIdx) ->
        for i in [0..2]
            tile = new CalendarTile @tileColours.getNextColour(), 2, null, "", "calendar", @calendarUrl, i
            @tileContainer.addTileToGroup(groupIdx, tile)

    makeSceneButton: (groupIdx, name, uri) ->
        tile = new SceneButton @tileColours.getNextColour(), 1, @automationServer.executeCommand, uri, name, "bulb-on", name
        @tileContainer.addTileToGroup(groupIdx, tile)

    automationServerReadyCb: (actions) =>
        # Callback when data received from the automation server (scenes/actions)
        if @checkActionGroupsChanged(@automationActionGroups, actions)
            @automationActionGroups = actions
            @updateUIWithActionGroups()

    checkActionGroupsChanged: (oldActionMap, newActionMap) ->
        # Deep object comparison to see if configuration has changed
        if Object.keys(oldActionMap).length isnt Object.keys(newActionMap).length then return true
        for servType, oldActions of oldActionMap
            if not (servType of newActionMap) then return true
            newActions = newActionMap[servType]
            if oldActions.length isnt newActions.length then return true
            for j in [0..oldActions.length-1]
                oldAction = oldActions[j]
                newAction = newActions[j]
                if oldAction.length isnt newAction.length then return true
                for i in [0..oldAction.length-1]
                    if oldAction[i] isnt newAction[i] then return true
        return false

    updateUIWithActionGroups: =>
        # Clear all tiles initially
        @tileContainer.clearTiles()
        # Add the clock and calendar back in
        @addClock(@favouritesGroupIdx)
        @addCalendar(@calendarGroupIdx)
        # Create tiles for all actions/scenes
        for servType, actionList of @automationActionGroups
            for action in actionList
                # Get ui group for the scene
                groupIdx = @sceneGroupIdx
                if action[2] isnt ""
                    if action[2] of @uiGroupMapping
                        groupIdx = @uiGroupMapping[action[2]]
                    else
                        # Make a new ui group if the room/action-group name is new
                        groupIdx = @tileContainer.addGroup action[2]
                        @uiGroupMapping[action[2]] = groupIdx
                # make the scene button
                @makeSceneButton groupIdx, action[1], action[3]
        # Apply the configuration for the tablet - handles favourites group etc
        if @jsonConfig isnt null
            @applyJsonConfig @jsonConfig
        # Re-do the layout of tiles
        @tileContainer.reDoLayout()

    applyJsonConfig: (jsonConfig) ->
        # Clear just the favourites group (and add clock back in)
        @tileContainer.clearTileGroup(@favouritesGroupIdx)
        @addClock(@favouritesGroupIdx)
        # Copy tiles that should be in favourites group
        for actionName, uiGroup of jsonConfig
            existingTile = @tileContainer.findExistingTile(actionName)
            if existingTile isnt null
                @makeSceneButton @favouritesGroupIdx, actionName, existingTile.clickParam

    configReadyCb: (@jsonConfig) =>
        @applyJsonConfig(@jsonConfig)
        @tileContainer.reDoLayout()

    actionOnUserIdle: =>
        $("html, body").animate({ scrollLeft: "0px" });
