PageView = require "../pageView"
Albums = require "../../collections/albums"
CoverListView = require "../coverList/coverListView"

class AlbumsView extends PageView
	tagName: "div"
	filter: ""
	initialize: ->
		@collection = new Albums
		@listenToOnce @collection, "reset", @render
		@collection.fetch reset: yes
					
	events:
		"input .searchBar-textbox": (event) ->
			@albumListing.filter = $(event.currentTarget).val()
			@albumListing.trigger "filterChanged"

		"click .DirectoryViewIcon": (event) ->
			console.log "dv click"
			@$el.find(".main-scrollingContent").addClass "listView"

		"click .AlbumSortIcon": (event) ->
			console.log "as click"
			@$el.find(".main-scrollingContent").removeClass "listView"
	render: ->
		console.log "rendering albums"
		result = AlbumsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Albums"
			searchBarClass: ""

		$content = result.find(".page-content").addClass("scroll")
		
		view = new CoverListView collection: @collection
		$content.append view.render().el

		@$el.empty().append(result)
		this
	
module.exports = AlbumsView
