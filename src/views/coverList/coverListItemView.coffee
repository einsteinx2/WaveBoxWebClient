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

		@$el.data "backbone-view", this
	
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

		this

	preloadArt: =>
		# If the image already exists, do nothing
		if @art?
			return

		if @fields.artId?
				# If there is associated art in WaveBox, load that
				@art = new Image
				@art.onload = @artLoaded
				@art.src = wavebox.apiClient.getArtUrl(@fields.artId)
				console.log("Preloading art for art id " + @fields.artId)
			else if @fields.musicBrainzId?
				# Otherwise, if it has a musicBrainzId, try to load a fanart thumbnail
				@art = new Image
				@art.onload = @artLoaded
				@art.src = wavebox.apiClient.getFanArtThumbUrl(@fields.musicBrainzId)
				console.log("Preloading art for musicBrainzId " + @fields.musicBrainzId)

		return

	artLoaded: =>
		@$el.children().first().css "background-image", "url(#{@art.src})"
		return
	
	

module.exports = CoverListItemView
