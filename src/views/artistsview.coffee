Artists = require "../collections/artists"
ArtistView = require "./artistview"

module.exports = Backbone.View.extend
	el: "#mainContent"
	initialize: ->
		@collection = new Artists
		@listenTo(@collection, "reset", @render)

	render: ->
		@$el.empty()
		$ul = $('<ul>')
		@collection.each (artist) =>
			view = new ArtistView model: artist
			result = view.render().el
			$ul.append result
		@$el.append $ul.children()
		this