PageView = require "../pageView"
AlbumsDynamicBoxListView = require "./albumsdynamicboxlistview"

class AlbumsView extends PageView
	tagName: "div"
	filter: ""
	initialize: ->
		@albumListing = new AlbumsDynamicBoxListView
					
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
		result = AlbumsView.__super__.render
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: "Albums"
			searchBarClass: ""

		result.find(".content").addClass("scroll").append @albumListing.render().el

		@$el.empty().append(result)
		@$el.find(".main-scrollingContent").addClass("noCollectionActions")
		this
	
module.exports = AlbumsView
