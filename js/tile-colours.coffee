class TileColours
	constructor: ->
		@tileColours = [ 
			"#a20025"           # crimson
			"#1ba1e2"           # cyan
			"#d80073"           # magenta
			"#741b47"           # deep purple
			"#a4c400"           # lime
			"#6a00ff"           # indigo
			"#76608a"           # mauve
			"#6d8764"           # olive
			"#aa00ff"           # violet
			"#647687"           # steel
			"#9900ff"           # purple
			"#2566c2"           # myblue
			"#bf9000"           # mustard
			"#00aba9"           # teal
			"#008a00"           # emerald
			"#f0a30a"           # amber
			"#825a2c"           # brown
			"#0050ef"           # cobalt
			]
		@curTileColour = 0

	getNextColour: ->
		colour = @tileColours[@curTileColour]
		@curTileColour += 1
		if @curTileColour >= @tileColours.length
			@curTileColour = 0
		colour
