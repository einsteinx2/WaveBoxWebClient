Artists = require "../collections/artists"
ArtistView = require "./artistview"

module.exports = Backbone.View.extend
	el: "#AlbumView"
	initialize: ->
		@listenTo(@collection, "reset", @render)

	render: ->
		@$el.empty()
		$ul = $('<ul>')
		@collection.each (artist) =>

			view = new ArtistView model: artist
			result = view.render().el
			console.log result
			$ul.append result
		console.log "result: #{$ul}"
		@$el.append $ul.children()
		this