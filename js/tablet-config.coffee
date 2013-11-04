class TabletConfig
	constructor: (@configURL) ->

	setReadyCallback: (@readyCallback) ->

	initTabletConfig: ->
		$.ajax @configURL,
			type: "GET"
			dataType: "text"
			crossDomain: true
			success: (data, textStatus, jqXHR) =>
				jsonText = jqXHR.responseText
				jsonData = $.parseJSON(jsonText)
				@readyCallback(jsonData)

