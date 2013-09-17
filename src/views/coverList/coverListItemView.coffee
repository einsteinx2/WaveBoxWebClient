Utils = require "../../utils/utils"

class CoverListItemView extends Backbone.View
	tagName: 'div'
	className: 'list-cover-item'
	template: _.template($("#template-cover-item").html())
	attributes:
		"draggable": true

	initialize: (options) ->
		if options?
			@fields = options.model.coverViewFields()
	
	events:
		"click": ->
			console.log @model
			wavebox.router.navigate @model.pageUrl(), trigger: true

		"dragstart": (e) ->
			wavebox.dragDrop.mediaDragStart @model

		"dragend": (e) ->
			wavebox.dragDrop.mediaDragEnd()

	render: ->
		@$el.append @template
			title: _.escape(@fields.title)
			artist: _.escape(@fields.artist)

		@preloadArt()

		this

	preloadArt: =>
		if @fields.artId?
			# If there is associated art in WaveBox, load that
			@art = new Image
			@art.onload = @artLoaded
			@art.src = wavebox.apiClient.getArtUrl(@fields.artId)
		else if @fields.itemId?
			# Otherwise, if it has an item id, try to load a fanart thumbnail
			@art = new Image
			@art.onload = @artLoaded
			@art.src = wavebox.apiClient.getFanArtThumbUrl(@fields.itemId)

	artLoaded: =>
		@$el.children().first().css "background-image", "url(#{@art.src})"
	
	

module.exports = CoverListItemView
