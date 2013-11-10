class TileContainer
	constructor: (@parentTag, @groupTitlesTag) ->
		@groups = []
		@groupCols = []
		@groupSepPixels = 30
		@groupTitlesTopMargin = 60
		@tileSepXPixels = 20
		@tileSepYPixels = 20
		@nextTileIdx = 0

	clearTiles: ->
		# Container of tile groups
		for group in @groups
			group.clearTiles()
		# This shouldn't be necessary after the first call as the above should have removed all tiles
		$(@parentTag).html """
	        <div id="sqTileContainer" style="width:3000px;height:350px;display:block;zoom:1;">
	        </div>
			"""

	clearTileGroup: (groupIdx) ->
		@groups[groupIdx].clearTiles()

	addGroup: (groupTitle) ->
		groupIdx = @groups.length
		newTileGroup = new TileGroup this, @groupTitlesTag, groupIdx, groupTitle
		@groups.push newTileGroup
		groupIdx

	calcLayout: ->
		winWidth = $(window).width()
		winHeight = $(window).height()
		isPortrait = (winWidth < winHeight)
		@tilesAcross = if isPortrait then 3 else 5
		@tilesDown = if isPortrait then 5 else 3
		@cellWidth = (winWidth - (@groupSepPixels * Math.floor((@tilesAcross - 1) / 3))) / @tilesAcross
		@cellHeight = (winHeight - @groupTitlesTopMargin) / @tilesDown
		@tileWidth = @cellWidth - @tileSepXPixels
		@tileHeight = @cellHeight - @tileSepYPixels
		@groupCols = []
		for group in @groups
			@groupCols.push group.getColsInGroup(@tilesDown, isPortrait)
		isPortrait

	getTileSize: (colSpan) ->
		[@tileWidth * colSpan + (@tileSepXPixels * (colSpan-1)), @tileHeight]

	getGroupStartX: (groupIdx) ->
		gIdx = 0
		xStart = 0
		while gIdx < groupIdx
			xStart += @groupCols[gIdx] * @cellWidth
			gIdx += 1
		xStart += groupIdx * @groupSepPixels
		xStart

	calcFontSizePercent: ->
		100 * Math.max(@cellWidth, @cellHeight) / 300

	getGroupTitlePos: (groupIdx) ->
		xStart = @getGroupStartX(groupIdx)
		[xStart, 10, "200%"]

	getCellPos: (groupIdx, colIdx, rowIdx) ->
		xStart = @getGroupStartX(groupIdx)
		colInGroup = colIdx
		cellX = xStart + colInGroup * @cellWidth
		cellY = @groupTitlesTopMargin + rowIdx * @cellHeight
		fontScaling = @calcFontSizePercent()
		[cellX, cellY, fontScaling]

	getNextTileIdx: ->
		@nextTileIdx += 1
		@nextTileIdx

	addTileToGroup: (groupIdx, tile) ->
		@groups[groupIdx].addExistingTile tile 

	reDoLayout: ->
		isPortrait = @calcLayout()
		for group in @groups
			group.repositionTiles(isPortrait)

	findExistingTile: (tileName) ->
		existingTile = null
		for group in @groups
			existingTile = group.findExistingTile(tileName)
			if existingTile	isnt null
				break
		existingTile
