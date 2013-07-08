Albums = require "../../collections/albums"
AlbumView = require "./albumview"
DynamicBoxListView = require "../dynamicboxlistview"

module.exports = class extends DynamicBoxListView
	tagName: "div"
	initialize: ->
		@filter = ""
		@collection = new Albums
		@collection.fetch reset: true
		@listenToOnce @collection, "reset", =>
			@render()
		@bind "filterChanged", @filterChanged, this

	className: "main-scrollingContent artistsMain scroll listView"
	render: ->
		$temp = $('<div>')
		filter = @filter.toLowerCase()
		@collection.each (album) =>
			albumN = album.get("albumName").toLowerCase()
			if albumN.indexOf(filter) >= 0
				view = new AlbumView model: album
				view.parent = this
				$temp.append view.render().el
		
		if not wavebox.isMobile()
			@$el.addClass "mainContentPadding"
		@$el.empty().append $temp.children()
		#@lookupImagesInViewport()
		this

	filterChanged: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 50
