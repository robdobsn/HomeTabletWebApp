class SceneButton extends Tile
	constructor: (tileBasics, @iconType, @buttonText) ->
		super tileBasics

	addToDoc: (elemToAddTo) ->
		super()
		@contents.append """
			<div class="sqSceneButtonIcon"><img src="img/light-bulb-on.png"></img></div>
			<div class="sqSceneButtonText"></div>
			"""
		if @buttonText.toLowerCase().indexOf("off") >= 0
			@iconType = "bulb-off"
		else if @buttonText.toLowerCase().indexOf(" on") >= 0
			@iconType = "bulb-on"
		@buttonText = @buttonText.replace(" Lights", "")
		@buttonText = @buttonText.replace(" Light", "")
		@setIcon(@iconType)
		@setText(@buttonText)

	setIcon: (@iconType) ->
		if iconType is 'bulb-on'
			iconUrl = 'img/light-bulb-on.png'
		else if iconType is 'bulb-off'
			iconUrl = 'img/light-bulb-off.png'
		$('#'+@tileId+" .sqSceneButtonIcon img").attr("src", iconUrl)

	setText: (@textStr) ->
		$('#'+@tileId+" .sqSceneButtonText").html textStr
