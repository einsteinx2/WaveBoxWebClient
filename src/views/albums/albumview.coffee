Utils = require "../../utils/utils"

module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'itemWrapper albumItem'
	template: _.template($("#template-album_container").html())

	events:
		"click": ->
			console.log "album click event fired! #{Date.now()}"
			wavebox.router.navigate "albums/#{@model.get 'albumId'}", trigger: true
	render: ->
		@$el.html @template
			albumTitle: _.escape(@model.get("albumName"))
			albumArtist: _.escape(@model.get("artistName") or "Artist Name")
			#color = ''+Math.floor(Math.random()*16777215).toString(16)
			#	@$el.attr 'data-img-url': "http://placehold.it/200/#{color}/ffffff"
			#@getImageUrl (url) =>
			#	if url?
			#		$(@$el.children().first()).css "background-image", "url(#{url}/preview)"
		this
