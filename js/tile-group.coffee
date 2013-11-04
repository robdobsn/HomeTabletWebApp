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

	getColsInGroupSimple: (tilesDown) ->
		@tilePositions = []
		vacantCells = []
		colIdx = 0
		rowIdx = 0
		for tile in @tiles
			while (colIdx + rowIdx*100) in vacantCells
				rowIdx+=1
				if rowIdx >= tilesDown
					rowIdx = 0
					colIdx += 1
			@tilePositions.push [ colIdx, rowIdx ]
			if tile.colSpan > 1
				for i in [1..tile.colSpan-1]
					vacantCells.push ((colIdx + i) + (rowIdx * 100))
			rowIdx += 1
			if rowIdx >= tilesDown
				rowIdx = 0
				colIdx += 1
		#Math.floor((group.numTiles() + @tilesDown - 1) / @tilesDown)
		colIdx + 1

	findBestPlaceForTile: (colSpan, tilesDown, tilesAcross) ->
		bestColIdx = 0
		bestRowIdx = 0
		for rowIdx in [0..tilesDown-1]
			for colIdx in [0..tilesAcross-1]
				if ((colIdx + colSpan) > tilesAcross) then continue
				posValid = true
				for tilePos in @tilePositions
					if tilePos[1] isnt rowIdx
						continue
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
