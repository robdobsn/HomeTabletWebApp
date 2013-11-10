class CalendarTile extends Tile
	constructor: (tileBasics, @calendarURL, @calDayIndex) ->
		super tileBasics
		@shortDayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		@calLineCount = 0; @calCharCount = 0; @calMaxLineLen = 0

	addToDoc: (elemToAddTo) ->
		super()
		cssTag = "sqInner"
		@setRefreshInterval(300, @requestCalUpdate, true)

	requestCalUpdate: ->
		$.ajax @calendarURL,
		type: "GET"
		dataType: "text"
		crossDomain: true
		success: (data, textStatus, jqXHR) =>
			jsonText = jqXHR.responseText
			jsonData = $.parseJSON(jsonText)
			@showCalendar(jsonData)

	showCalendar: (jsonData) ->
		if not ("calEvents" of jsonData)
			return
		newHtml = ""

		# Calendar boxes can be for each of the next few days so see which date this one is for
		reqDate = new Date()
		reqDate.setDate(reqDate.getDate()+@calDayIndex);
		reqDateStr = @toZeroPadStr(reqDate.getFullYear(), 4) + 
				@toZeroPadStr(reqDate.getMonth()+1, 2) +
				@toZeroPadStr(reqDate.getDate(), 2)
		calTitle = "Today"
		if @calDayIndex isnt 0
			calTitle = @shortDayNames[reqDate.getDay()]

		# Format the text to go into the calendar and keep stats on it for font sizing
		@calLineCount = 0; @calCharCount = 0; @calMaxLineLen = 0
		for event in jsonData["calEvents"]
			if event["eventDate"] is reqDateStr
				@calLineCount += 1
				newLine = """
					<span class="sqCalEventStart">#{event["eventTime"]}</span>
					<span class="sqCalEventDur"> (#{@formatDurationStr(event["duration"])}) </span>
					<span class="sqCalEventSummary">#{event["summary"]}</span>
					"""
				newHtml += """
					<li class="sqCalEvent">
						#{newLine}
					</li>
					"""
				@calCharCount += newLine.length
				@calMaxLineLen = if @calMaxLineLen < newLine.length then newLine.length else @calMaxLineLen

		# Place the calendar text
		@contents.html """
			<div class="sqCalTitle">#{calTitle}</div>
			<ul class="sqCalEvents">
				#{newHtml}
			</ul>
			"""
		# Calculate optimal font size
		@recalculateFontScaling()

	# Utility function for leading zeroes
	toZeroPadStr: (value, digits) ->
		s = "0000" + value
		s.substr(s.length-digits)

	# Override reposition to handle font scaling
	reposition: (posX, posY, sizeX, sizeY, fontScaling) ->
		super(posX, posY, sizeX, sizeY, fontScaling)
		@recalculateFontScaling()

	# Provide a different font scaling based on the amount of text in the calendar box
	recalculateFontScaling: () ->
		if not @sizeY? or (@calLineCount is 0) then return
		calText = @getElement(".sqCalEvents")
		textHeight = calText.height()
		if not textHeight? then return
		availHeight = @sizeY * 0.9
		startScale = availHeight / textHeight
		@setContentFontScaling(startScale)
		sizeInc = 1.0
		# Iterate through possible sizes in a kind of binary tree search
		for i in [0..6]
			calText = @getElement(".sqCalEvents")
			textHeight = calText.height()
			if not textHeight? then return
			if textHeight > availHeight
				startScale = startScale * (1 - (sizeInc/2))
				@setContentFontScaling(startScale)
			else if textHeight < (availHeight * 0.75)
				startScale = startScale * (1 + sizeInc)
				@setContentFontScaling(startScale)
			else
				break
			sizeInc *= 0.5
	
	formatDurationStr: (val) ->
		dur = val.split(":")
		days = parseInt(dur[0])
		hrs = parseInt(dur[1])
		mins = parseInt(dur[2])
		if days is 0 and hrs isnt 0 and mins is 30
			outStr = (hrs+0.5) + "h"
		else
			outStr = if days is 0 then "" else (days + "d")
			outStr += if hrs is 0 then "" else (hrs + "h")
			outStr += if mins is 0 then "" else (mins + "m")

