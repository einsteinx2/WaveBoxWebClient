PlayQueueItemView = require './playQueueItemView'

module.exports = Backbone.View.extend
	el: "#QueueScroller"
	initialize: ->
		console.log @model
		@listenTo @model, "change", @render

	render: ->
		$container = $("<div>")
		@model.tracks.each (track) ->
			view = new PlayQueueItemView model: track
			$container.append view.render().el
		
		@$el.empty().append $container.children()
