Artists = require "../../collections/artists"
ArtistView = require "./artistview"
DynamicBoxListView = require "../dynamicboxlistview"

module.exports = class extends DynamicBoxListView
	tagName: "div"
	initialize: ->
		@filter = ""
		@collection = new Artists
		@collection.fetch reset: true
		@listenToOnce @collection, "reset", =>
			@render()
		@bind "filterChanged", @filterChanged, this

	className: "main-scrollingContent artistsMain scroll"
	render: ->
		$temp = $('<div>')
		filter = @filter.toLowerCase()
		@collection.each (artist) =>
			artistN = artist.get("artistName").toLowerCase()
			if artistN.indexOf(filter) >= 0
				view = new ArtistView model: artist
				$temp.append view.render().el
		@$el.empty().append $temp.children()
		this

	filterChanged: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 50
