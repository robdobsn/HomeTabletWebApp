class TileGroup
	constructor: (@tileContainer, @groupTitlesTag, @groupIdx, @groupTitle) ->
		@tiles = []
		@tilePositions = []
		@groupIdTag = "sqGroupTitle" + groupIdx
		$(groupTitlesTag).append """
	        <div class="sqGroupTitle" id="#{@groupIdTag}">#{@groupTitle}
	        </div>
			"""

	clearTiles: ->
		for tile in @tiles
			tile.removeFromDoc()
		@tiles = []

	numTiles: ->
		@tiles.length

	findBestPlaceForTile: (colSpan, tilesDown, tilesAcross) ->
		# Algorithm to find best location for a tile
		# Exhaustive search for a gap large enough
		bestColIdx = 0
		bestRowIdx = 0
		# This time work across - filling each row before moving down
		for rowIdx in [0..tilesDown-1]
			for colIdx in [0..tilesAcross-1]
				# Check if the tile will fit in the remaining columns
				if ((colIdx + colSpan) > tilesAcross) then continue
				posValid = true
				for tilePos in @tilePositions
					if tilePos[1] isnt rowIdx
						continue
					# Go through each remaining column that would be covered
					# and check the new tile doesn't impinge on existing tile
					for colTest in [colIdx..colIdx+colSpan-1]
						for spanTest in [tilePos[0]..tilePos[0]+tilePos[2]-1] 
							if spanTest is colTest
								posValid = false
								break
					if not posValid then break
				bestColIdx = colIdx
				bestRowIdx = rowIdx
				if posValid then break
			if posValid then break
		[bestColIdx, bestRowIdx, colSpan]

	getColsInGroup: (tilesDown) ->
		# Simple algorithm to find the number of columns in a tile-group
		# May get it wrong if there are many wider tiles and not enough single
		# tiles to fill the gaps
		@tiles.sort(@sortByTileWidth)
		@tilePositions = []
		cellCount = 0
		maxColSpan = 1
		for tile in @tiles
			cellCount += tile.colSpan
			maxColSpan = if maxColSpan < tile.colSpan then tile.colSpan else maxColSpan
		estColCount = Math.floor((cellCount + tilesDown - 1) / tilesDown)
		estColCount = if estColCount < maxColSpan then maxColSpan else estColCount
		for tile, tileIdx in @tiles
			@tilePositions.push @findBestPlaceForTile(tile.colSpan, tilesDown, estColCount)
		estColCount

	addTile: (tileColour, colSpan) ->
		tile = new Tile tileColour, colSpan
		tile.setTileIndex(@tileContainer.getNextTileIdx())
		tile.addToDoc()
		@tiles.push tile

	addExistingTile: (tile) ->
		tile.setTileIndex(@tileContainer.getNextTileIdx())
		tile.addToDoc()
		@tiles.push tile

	sortByTileWidth: (a, b) ->
		a.colSpan - b.colSpan

	repositionTiles: ->
		[titleX, titleY, fontSize] = @tileContainer.getGroupTitlePos(@groupIdx)
		$("#"+@groupIdTag).css {
			"margin-left": titleX + "px", 
			"margin-top": titleY + "px",
			"font-size": fontSize
			}
		# Order tiles so widest are at the end
		for tile, tileIdx in @tiles
			[tileWidth, tileHeight] = @tileContainer.getTileSize(tile.colSpan)
			[xPos, yPos, fontScaling] = @tileContainer.getCellPos(@groupIdx, @tilePositions[tileIdx][0], @tilePositions[tileIdx][1])
			@tiles[tileIdx].reposition xPos, yPos, tileWidth, tileHeight, fontScaling

	findExistingTile: (tileName) ->
		existingTile = null
		for tile in @tiles
			if tile.tileName is tileName
				existingTile = tile
				break
		existingTile
