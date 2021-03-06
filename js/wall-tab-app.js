// Generated by CoffeeScript 1.6.3
var WallTabApp,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

WallTabApp = (function() {
  function WallTabApp() {
    this.actionOnUserIdle = __bind(this.actionOnUserIdle, this);
    this.configReadyCb = __bind(this.configReadyCb, this);
    this.updateUIWithActionGroups = __bind(this.updateUIWithActionGroups, this);
    this.automationServerReadyCb = __bind(this.automationServerReadyCb, this);
    this.tileColours = new TileColours;
    this.rdHomeServerUrl = "http://macallan:5000";
    this.calendarUrl = this.rdHomeServerUrl + "/calendars/api/v1.0/cal";
    this.automationServerUrl = this.rdHomeServerUrl + "/automation/api/v1.0";
    this.tabletConfigUrl = this.rdHomeServerUrl + "/tablet/api/v1.0/config";
  }

  WallTabApp.prototype.go = function() {
    var _this = this;
    $("body").append("<div id=\"sqGroupTitles\"></div>\n<div id=\"sqWrapper\">\n  <div id=\"sqTileWrapper\">\n  </div>\n</div>");
    this.userIdleCatcher = new UserIdleCatcher(30, this.actionOnUserIdle);
    this.automationActionGroups = [];
    this.uiGroupMapping = {};
    this.automationServer = new AutomationServer(this.automationServerUrl);
    this.automationServer.setReadyCallback(this.automationServerReadyCb);
    this.tabletConfig = new TabletConfig(this.tabletConfigUrl);
    this.tabletConfig.setReadyCallback(this.configReadyCb);
    this.tileContainer = new TileContainer("#sqTileWrapper", "#sqGroupTitles");
    this.tileContainer.clearTiles();
    this.favouritesGroupIdx = this.tileContainer.addGroup("Home");
    this.addClock(this.favouritesGroupIdx);
    this.calendarGroupIdx = this.tileContainer.addGroup("Calendar");
    this.addCalendar();
    this.sceneGroupIdx = this.tileContainer.addGroup("Scenes");
    this.tileContainer.reDoLayout();
    $(window).on('orientationchange', function() {
      return _this.tileContainer.reDoLayout();
    });
    $(window).on('resize', function() {
      return _this.tileContainer.reDoLayout();
    });
    this.requestActionAndConfigData();
    return setInterval(function() {
      return _this.requestActionAndConfigData();
    }, 300000);
  };

  WallTabApp.prototype.requestActionAndConfigData = function() {
    this.automationServer.getActionGroups();
    return this.tabletConfig.initTabletConfig();
  };

  WallTabApp.prototype.addClock = function(groupIdx) {
    var tile, tileBasics, visibility;
    visibility = "all";
    tileBasics = new TileBasics(this.tileColours.getNextColour(), 3, null, "", "clock", visibility);
    tile = new Clock(tileBasics);
    return this.tileContainer.addTileToGroup(groupIdx, tile);
  };

  WallTabApp.prototype.addCalendar = function(onlyAddToGroupIdx) {
    var calDayIdx, calG, colSpan, colSpans, favG, groupIdx, groupInfo, i, orientation, tile, tileBasics, visibility, _i, _results;
    if (onlyAddToGroupIdx == null) {
      onlyAddToGroupIdx = null;
    }
    _results = [];
    for (orientation = _i = 0; _i <= 1; orientation = ++_i) {
      calG = this.calendarGroupIdx;
      favG = this.favouritesGroupIdx;
      if (orientation === 0) {
        visibility = "all";
        groupInfo = [calG, calG, calG];
        calDayIdx = [0, 1, 2];
        colSpans = [2, 2, 2];
      } else {
        visibility = "portrait";
        groupInfo = [favG, favG, calG, calG];
        calDayIdx = [0, 1, 3, 4];
        colSpans = [3, 3, 2, 2];
      }
      _results.push((function() {
        var _j, _ref, _results1;
        _results1 = [];
        for (i = _j = 0, _ref = groupInfo.length - 1; 0 <= _ref ? _j <= _ref : _j >= _ref; i = 0 <= _ref ? ++_j : --_j) {
          groupIdx = groupInfo[i];
          colSpan = colSpans[i];
          if (!((onlyAddToGroupIdx != null) && (onlyAddToGroupIdx !== groupIdx))) {
            tileBasics = new TileBasics(this.tileColours.getNextColour(), colSpan, null, "", "calendar", visibility);
            tile = new CalendarTile(tileBasics, this.calendarUrl, calDayIdx[i]);
            _results1.push(this.tileContainer.addTileToGroup(groupIdx, tile));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      }).call(this));
    }
    return _results;
  };

  WallTabApp.prototype.makeSceneButton = function(groupIdx, name, uri, visibility) {
    var tile, tileBasics;
    if (visibility == null) {
      visibility = "all";
    }
    tileBasics = new TileBasics(this.tileColours.getNextColour(), 1, this.automationServer.executeCommand, uri, name, visibility);
    tile = new SceneButton(tileBasics, "bulb-on", name);
    return this.tileContainer.addTileToGroup(groupIdx, tile);
  };

  WallTabApp.prototype.automationServerReadyCb = function(actions) {
    if (this.checkActionGroupsChanged(this.automationActionGroups, actions)) {
      this.automationActionGroups = actions;
      return this.updateUIWithActionGroups();
    }
  };

  WallTabApp.prototype.checkActionGroupsChanged = function(oldActionMap, newActionMap) {
    var i, j, newAction, newActions, oldAction, oldActions, servType, _i, _j, _ref, _ref1;
    if (Object.keys(oldActionMap).length !== Object.keys(newActionMap).length) {
      return true;
    }
    for (servType in oldActionMap) {
      oldActions = oldActionMap[servType];
      if (!(servType in newActionMap)) {
        return true;
      }
      newActions = newActionMap[servType];
      if (oldActions.length !== newActions.length) {
        return true;
      }
      for (j = _i = 0, _ref = oldActions.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; j = 0 <= _ref ? ++_i : --_i) {
        oldAction = oldActions[j];
        newAction = newActions[j];
        if (oldAction.length !== newAction.length) {
          return true;
        }
        for (i = _j = 0, _ref1 = oldAction.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          if (oldAction[i] !== newAction[i]) {
            return true;
          }
        }
      }
    }
    return false;
  };

  WallTabApp.prototype.updateUIWithActionGroups = function() {
    var action, actionList, groupIdx, servType, _i, _len, _ref;
    this.tileContainer.clearTiles();
    this.addClock(this.favouritesGroupIdx);
    this.addCalendar();
    _ref = this.automationActionGroups;
    for (servType in _ref) {
      actionList = _ref[servType];
      for (_i = 0, _len = actionList.length; _i < _len; _i++) {
        action = actionList[_i];
        groupIdx = this.sceneGroupIdx;
        if (action[2] !== "") {
          if (action[2] in this.uiGroupMapping) {
            groupIdx = this.uiGroupMapping[action[2]];
          } else {
            groupIdx = this.tileContainer.addGroup(action[2]);
            this.uiGroupMapping[action[2]] = groupIdx;
          }
        }
        this.makeSceneButton(groupIdx, action[1], action[3]);
      }
    }
    if (this.jsonConfig !== null) {
      this.applyJsonConfig(this.jsonConfig);
    }
    return this.tileContainer.reDoLayout();
  };

  WallTabApp.prototype.applyJsonConfig = function(jsonConfig) {
    var actionName, existingTile, uiGroup, _results;
    this.tileContainer.clearTileGroup(this.favouritesGroupIdx);
    this.addClock(this.favouritesGroupIdx);
    this.addCalendar(this.favouritesGroupIdx);
    _results = [];
    for (actionName in jsonConfig) {
      uiGroup = jsonConfig[actionName];
      existingTile = this.tileContainer.findExistingTile(actionName);
      if (existingTile !== null) {
        _results.push(this.makeSceneButton(this.favouritesGroupIdx, actionName, existingTile.tileBasics.clickParam));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  WallTabApp.prototype.configReadyCb = function(jsonConfig) {
    this.jsonConfig = jsonConfig;
    this.applyJsonConfig(this.jsonConfig);
    return this.tileContainer.reDoLayout();
  };

  WallTabApp.prototype.actionOnUserIdle = function() {
    return $("html, body").animate({
      scrollLeft: "0px"
    });
  };

  return WallTabApp;

})();
