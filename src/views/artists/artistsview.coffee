PageView = require "../pageView"
Artists = require "../../collections/artists"
CoverListView = require "../coverList/coverListView"

class ArtistsView extends PageView
	tagName: "div"
	filter: ""
	initialize: (options) ->
		if options? and options.genreId?
			@collection = new Genre
		else
			@collection = new Artists

		@listenToOnce @collection, "reset", @render
		@collection.fetch reset: true
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

		@covers = new CoverListView collection: @collection
		$content.append @covers.render().el

		@$el.empty().append(result.children())
		this

module.exports = ArtistsView
