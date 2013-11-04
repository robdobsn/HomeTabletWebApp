class AutomationServer
	constructor: (@serverURL) ->
		@ACTIONS_URI = @serverURL + "/actions"
		@EXEC_URI = @serverURL + "/exec"

	setReadyCallback: (@readyCallback) ->

	getActionGroups: ->
		# Get the action-groups/scenes
		$.ajax @ACTIONS_URI,
			type: "GET"
			dataType: "json"
			success: (data, textStatus, jqXHR) =>
				@readyCallback(data)
			error: (jqXHR, textStatus, errorThrown) =>
				console.log ("Get Actions failed: " + textStatus + " " + errorThrown)

	executeCommand: (cmdParams) =>
		# Execute command on the server
		$.ajax @EXEC_URI + "/" + cmdParams,
			type: "GET"
			dataType: "text"
			success: (data, textStatus, jqXHR) =>

			error: (jqXHR, textStatus, errorThrown) =>
				console.log ("Exec command failed: " + textStatus + " " + errorThrown)
