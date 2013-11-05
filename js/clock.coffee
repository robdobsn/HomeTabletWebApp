class Clock extends Tile
	constructor: (bkColour, colSpan, clickFn, clickParam, tileName) ->
		super bkColour, colSpan, clickFn, clickParam, tileName

	addToDoc: (elemToAddTo) ->
		super()
		@contents.append """
			<div class="sqClockDow"></div>
			<div class="sqClockDayMonthYear"></div>
			<ul class="sqClockTime">
				<li class="sqClockHours">4</li> 
				<li class="sqClockPoint1">:</li> 
				<li class="sqClockMins"></li> 
				<li class="sqClockPoint2">:</li> 
				<li class="sqClockSecs"></li>
			</ul>
			"""
		cssTag = "sqInner"
		dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
		shortDayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		shortMonthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
		setInterval =>
			dt = new Date()
			$('#'+@tileId+" .sqClockDayMonthYear").html shortDayNames[dt.getDay()] + " " + dt.getDate() + " " + shortMonthNames[dt.getMonth()] + " " + dt.getFullYear()
			$('#'+@tileId+" .sqClockHours").html (if dt.getHours() < 10 then "0" else "") + dt.getHours()
			$('#'+@tileId+" .sqClockMins").html (if dt.getMinutes() < 10 then "0" else "") + dt.getMinutes()
			$('#'+@tileId+" .sqClockSecs").html (if dt.getSeconds() < 10 then "0" else "") + dt.getSeconds()
		, 1000
