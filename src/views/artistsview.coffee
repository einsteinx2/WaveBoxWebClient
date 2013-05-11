Artists = require "../collections/artists"
ArtistView = require "./artistview"

module.exports = Backbone.View.extend
	el: "#mainContent"
	filter: ""
	initialize: ->
		@collection = new Artists
		@listenTo(@collection, "reset", @render)
		that = this
		$("#mainSearchField").on "input", ->
			that.filter = $(this).val()
			timeout = `setTimeout(function() {clearTimeout(timeout); that.render.call(that)}, 50);`
		
		console.log @filter
			
	render: ->
		start = new Date()
		@$el.empty()
		$ul = $('<div>')
		filter = @filter.toLowerCase()
		@collection.each (artist) =>
			artistN = artist.get("artistName").toLowerCase()
			if artistN.indexOf(filter) >= 0
				view = new ArtistView model: artist
				$ul.append view.render().el
		@$el.append $ul
		end = new Date()
		console.log "render took #{end.getTime() - start.getTime()}ms"
		this
