module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'itemWrapper artistItem'
	template: _.template($("#template-cover-item").html())
	attributes:
		"draggable": "true"

	events:
		"click": ->
			console.log "artist click event fired! #{Date.now()}"
			wavebox.router.navigate "artists/#{@model.get 'artistId'}", trigger: true
		"dragstart": (e) ->
			wavebox.dragDrop.mediaDragStart @model
		"dragend": ->
			wavebox.dragDrop.mediaDragEnd()
	render: ->
		random = Math.floor(Math.random() * 100)
		if random is 12 then random = 13
		@$el.html @template
			itemTitle: @model.get "artistName"
			#color = ''+Math.floor(Math.random()*16777215).toString(16)
			#	@$el.attr 'data-img-url': "http://placehold.it/200/#{color}/ffffff"
			#@getImageUrl (url) =>
			#	if url?
			#		$(@$el.children().first()).css "background-image", "url(#{url}/preview)"
		this

	getImageUrl: (callback) ->
		escapedName = @model.get("artistName").replace(/\ /g, "+")
		url = "http://musicbrainz.org/ws/2/artist?query=#{escapedName}&limit=2&fmt=json"
		$.get url, (data) ->
			newUrl = "http://api.fanart.tv/webservice/artist/40452bf888b8fce118c1b975ce2793c0/#{data.artist[0].id}/json/"
			$.get newUrl, (data) ->
				console.log data
				artist = data[Object.keys(data)[0]]
				if callback?
					console.log artist.artistbackground[0].url
					callback artist.artistbackground[0].url
