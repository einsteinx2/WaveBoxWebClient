PageView = require "../pageView"
Artists = require "../../collections/artists"
CoverListView = require "../coverList/coverListView"

class ArtistsView extends PageView
	tagName: "div"
	filter: ""
	initialize: ->
		@collection = new Artists
		@listenToOnce @collection, "reset", @render
		@collection.fetch reset: true

					
	events:
		"input .searchBar-textbox": (event) ->
			@artistListing.filter = $(event.currentTarget).val()
			@artistListing.trigger "filterChanged"

		"click .DirectoryViewIcon": (event) ->
			@$el.find(".main-scrollingContent").addClass "listView"

		"click .AlbumSortIcon": (event) ->
			@$el.find(".main-scrollingContent").removeClass "listView"

			
	render: ->
		result = ArtistsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Artists"
			search: yes
		$content = result.find(".page-content").addClass("scroll")

		covers = new CoverListView collection: @collection
		$content.append covers.render().el

		@$el.empty().append(result)
		this
	
module.exports = ArtistsView
