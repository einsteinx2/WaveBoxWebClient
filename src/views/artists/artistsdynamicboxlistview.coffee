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

	className: "list-cover listView"
	render: ->
		$temp = $('<div>')
		filter = @filter.toLowerCase()
		@collection.each (artist) =>
			artistN = artist.get("artistName").toLowerCase()
			if artistN.indexOf(filter) >= 0
				view = new ArtistView model: artist
				view.parent = this
				$temp.append view.render().el
		@$el.empty().append $temp.children()
		#@lookupImagesInViewport()
		this

	filterChanged: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 50

	lookupImagesInViewport: ->
		viewTop = @$el.scrollTop()
		viewBottom = viewTop + @$el.height()
		@collection.each (artist) ->
			console.log artist.el
			artistOffset = artist.$el.offset().top
			if artistOffset >= viewTop and artistOffset <= viewBottom
				console.log artist
			
