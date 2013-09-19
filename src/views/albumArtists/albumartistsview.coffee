PageView = require "../pageView"
AlbumArtists = require "../../collections/albumArtists"
CoverListView = require "../coverList/coverListView"
Genre = require '../../models/genre'

class AlbumArtistsView extends PageView
	tagName: "div"
	filter: ""
	initialize: (options) ->
		if options? and options.genreId?
			@collection = new Genre null, genreId: options.genreId
		else
			@collection = new AlbumArtists

		console.log @collection

		@collection.fetch reset: yes
		
		@listenToOnce @collection, "sync", =>
			@fetched = yes
			@render()
		@el.addEventListener "input", @search, yes

	events:
		"click .DirectoryViewIcon": (event) ->
			@$el.find(".main-scrollingContent").addClass "listView"

		"click .AlbumSortIcon": (event) ->
			@$el.find(".main-scrollingContent").removeClass "listView"

		"input .page-search-textbox": (event) ->
			@covers.model.set "filter", $(event.target).val()
			
	render: ->
		result = AlbumArtistsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Artists"
			search: yes
		$content = result.find(".page-content").addClass("scroll")

		if @fetched
			albumArtists =
				if @collection.constructor.name is "AlbumArtists"
					@collection
				else if @collection.constructor.name is "Genre"
					@collection.get("albumArtists")

			console.log @collection
			@covers = new CoverListView collection: albumArtists
			$content.append @covers.render().el

		@$el.empty().append(result.children())
		this

module.exports = AlbumArtistsView
