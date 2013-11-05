class TabletConfig
	constructor: (@configURL) ->

	setReadyCallback: (@readyCallback) ->

	initTabletConfig: ->
		# To avoid giving each tablet a name or other ID
		# the tablet's IP address is used to retrieve the config
		$.ajax @configURL,
			type: "GET"
			dataType: "text"
			crossDomain: true
			success: (data, textStatus, jqXHR) =>
				jsonText = jqXHR.responseText
				jsonData = $.parseJSON(jsonText)
				@readyCallback(jsonData)

