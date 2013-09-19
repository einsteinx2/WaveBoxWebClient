PageView = require "../pageView"
Artists = require "../../collections/artists"
AlbumArtists = require "../../collections/albumArtists"
CoverListView = require "../coverList/coverListView"
Genre = require '../../models/genre'

class ArtistsView extends PageView
	tagName: "div"
	filter: ""
	initialize: (options) ->
		if options? and options.genreId?
			@collection = new Genre null, genreId: options.genreId
		else if options? and options.isAlbumArtist? and options.isAlbumArtist
			@collection = new AlbumArtists
		else
			@collection = new Artists

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
		result = ArtistsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Artists"
			search: yes
		$content = result.find(".page-content").addClass("scroll")

		if @fetched
			artists =
				if @collection.constructor.name is "Genre"
					@collection.get("artists")
				else
					@collection

			console.log @collection
			@covers = new CoverListView collection: artists
			$content.append @covers.render().el

		@$el.empty().append(result.children())
		this

module.exports = ArtistsView
