PageView = require "../pageView"
ArtistsDynamicBoxListView = require "./artistsdynamicboxlistview"

class ArtistsView extends PageView
	tagName: "div"
	filter: ""
	initialize: ->
		@artistListing = new ArtistsDynamicBoxListView
					
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
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: "Artists"
			searchBarClass: ""
		document.title = "Wave - Artists"

		@$el.empty().append(result).append @artistListing.render().el
		@$el.find(".main-scrollingContent").addClass("noCollectionActions")
		this
	
module.exports = ArtistsView
