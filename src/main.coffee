k = $(".subtext").find('a[href^=item]').filter(":not(:contains(discuss))")

totalNew = 0

k.each ->
	href = $(this).attr("href")
	storyID = href.split("=")[1]
	
	commentText = $(this).text()
	numComments = parseInt commentText.split(" ")[0], 10
    
	$.storage.get storyID, null, (val) =>
		oldNumComments = val
		if oldNumComments?
			diff = numComments - oldNumComments
			if diff isnt 0
				totalNew += diff
				$(this).html("#{commentText} <strong>(#{diff} new)</strong>")
