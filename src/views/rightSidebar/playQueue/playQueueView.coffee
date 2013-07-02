PlayQueueItemView = require './playQueueItemView'

module.exports = Backbone.View.extend
	el: "#QueueScroller"
	initialize: ->
		console.log @model
		@listenTo @model, "change", @render
		@listenTo wavebox.audioPlayer, "newSong", @render
		@listenTo wavebox.notifications, "mediaDragStart", @mediaDragStart
		@listenTo wavebox.notifications, "mediaDragEnd", @mediaDragEnd

	render: ->
		$container = $("<div>")
		@model.tracks.each (track) ->
			view = new PlayQueueItemView model: track
			$container.append view.render().el
		
		@$el.empty().append $container.children()

	mediaDragStart: ->
		console.log @el
		@$el.append($("<div>").addClass("dropzone-callout"))

	mediaDragEnd: ->
		@$el.find(".dropzone-callout").remove()

