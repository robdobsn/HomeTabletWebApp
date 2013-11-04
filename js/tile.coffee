class Tile
	constructor: (@bkColour, @colSpan, @clickFn, @clickParam, @tileName) ->
		@contentFontScaling = 1

	addToDoc: ->
		@parentTag = "#sqTileContainer"
		@tileId = "sqTile" + @tileIdx
		$(@parentTag).append """
			<a class="sqTile" id="#{@tileId}" href="javascript:void(0);" style="background-color:#{@bkColour};display:block;opacity:1;">
			  <div class="sqInner">
			  </div>
			</div>
			"""
		if @clickFn?
			$("##{@tileId}").click =>
				(@clickFn) @clickParam
		@contents = $("##{@tileId}>.sqInner")

	removeFromDoc: ->
		$('#'+@tileId).remove()

	setTileIndex: (@tileIdx) ->

	reposition: (@posX, @posY, @sizeX, @sizeY, @fontScaling) ->
		@setPositionCss(@posX, @posY, @sizeX, @sizeY, @fontScaling)

	setPositionCss: (posX, posY, sizeX, sizeY, fontScaling) ->
		$('#'+@tileId).css {
			"margin-left": posX + "px", 
			"margin-top": posY + "px",
			"width": sizeX + "px", 
			"height": sizeY + "px", 
			"font-size": (fontScaling * @contentFontScaling) + "%"
			}

	setContentFontScaling: (@contentFontScaling) ->
		@setPositionCss(@posX, @posY, @sizeX, @sizeY, @fontScaling)

	getElement: (element) ->
		$('#'+@tileId + " " + element)
