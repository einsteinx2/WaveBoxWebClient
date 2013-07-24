Utils = require "../../utils/utils"

module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'list-cover-item albumItem'
	template: _.template($("#template-cover-item-two-lines").html())
	
	attributes:
		"draggable": "true"

	events:
		"click": ->
			console.log "album click event fired! #{Date.now()}"
			wavebox.router.navigate "albums/#{@model.get 'albumId'}", trigger: true

		"dragstart": (e) ->
			wavebox.dragDrop.mediaDragStart @model

		"dragend": (e) ->
			wavebox.dragDrop.mediaDragEnd()

	render: ->
		@$el.html @template
			albumTitle: _.escape(@model.get("albumName"))
			albumArtist: _.escape(@model.get("artistName") or "Artist Name")
		this
