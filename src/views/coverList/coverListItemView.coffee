Utils = require "../../utils/utils"

class CoverListItemView extends Backbone.View
	tagName: 'div'
	className: 'list-cover-item albumItem'
	template: _.template($("#template-cover-item").html())

	initialize: (options) ->
		if options?
			@model = options
			@fields = options.coverViewFields()
	
	attributes:
		"draggable": "true"

	events:
		"click": ->
			wavebox.router.navigate @model.pageUrl(), trigger: true

		"dragstart": (e) ->
			wavebox.dragDrop.mediaDragStart @model

		"dragend": (e) ->
			wavebox.dragDrop.mediaDragEnd()

	render: ->
		@$el.html @template
			title: _.escape(@fields.title)
			artist: _.escape(@fields.artist)

		if @fields.artId? 
			console.log @fields.artId
			@art = new Image
			@art.onload = @artLoaded
			@art.src = wavebox.apiClient.getArtUrl(@fields.artId, 150)

		this

	artLoaded: =>
		@$el.children().first().css "background-image", "url(#{@art.src})"
	
	

module.exports = CoverListItemView
