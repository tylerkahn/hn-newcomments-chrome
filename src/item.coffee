
highlightComments = (ncColor, ecColor, firstView, highlight, onUserThreadPage=false) ->
	totalNew = 0
	
	showTotalNew = ->
		if onUserThreadPage and totalNew isnt 0
			$(".pagetop").eq(1).children(":last").before("#{totalNew} | ")
	
	$("document").ready ->
		$comments = $('.default') 
		lastComment = $comments.last().get(0)
		$comments.each ->
			commentID = $(this).find("a[href^=item]:first").attr("href").split("=")[1]
		
			$dotComment = $(this).find(".comment")
		
			hasReply = $dotComment.children().eq(-1).text() == "reply"
		
			commentText = $dotComment.text()
			commentText = commentText.slice(0, -5) if hasReply
		
			commentTextHash = $.md5 commentText
		
		
			$.storage.get commentID, null, (oldCommentTextHash) =>
				if not firstView and commentTextHash isnt oldCommentTextHash
					$v = if highlight is "whole_comment" then $(this) else $(this).find(".comhead")
					if oldCommentTextHash?
						$v.css {backgroundColor : ecColor}
					else
						totalNew++
						$v.css {backgroundColor : ncColor}
				$.storage.set commentID, commentTextHash
				if $(this).get(0) is lastComment
					showTotalNew()
	
	
	

saveNumComments = (ncColor, ecColor, highlight) ->
	storyID = window.location.href.split("=")[1]
	
	$.storage.get storyID, null, (oldNumComments) ->
		firstView = not oldNumComments?
		
		k = $(".subtext").find('a[href^=item]').eq(0)
		commentText = k.text()
		numComments = if (commentText is "discuss") then 0 else parseInt commentText.split(" ")[0], 10
		
		$.storage.set storyID, numComments
		if not firstView
			diff = numComments - oldNumComments
			if diff isnt 0
				k.html "#{commentText} <strong>(#{diff} new)</strong>"
		
		highlightComments ncColor, ecColor, firstView, highlight


chrome.extension.sendRequest {method: "getOptions"}, (options) ->
	ncBG 		= options.new_color 	or '#bde4ff'
	ecBG		= options.edited_color 	or '#e0e0e0'
	username 	= options.username		or "#notavalidname"
	highlight 	= options.highlight
	
	href = window.location.href
	onUserThreadPage = href.match("threads\\?id=#{username}")?
	onItemPage		 = href.match("item\\?id=")?
	if onUserThreadPage || onItemPage
		onTopLevelStoryPage = $(".title").children(".comhead")[0]?
		if onTopLevelStoryPage
			saveNumComments ncBG, ecBG, highlight
		else 
			highlightComments ncBG, ecBG, false, highlight, onUserThreadPage

	
