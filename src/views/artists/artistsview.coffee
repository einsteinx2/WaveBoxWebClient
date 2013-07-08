ArtistsDynamicBoxListView = require "./artistsdynamicboxlistview"

module.exports = Backbone.View.extend
	tagName: "div"
	filter: ""
	template: _.template($("#template-pageView").html())
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
		result = @template
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: "Artists"
			searchBarClass: ""
		document.title = "Wave - Artists"

		@$el.empty().append $("<div>").append(result).append @artistListing.render().el
		@$el.find(".main-scrollingContent").addClass("noCollectionActions")
		this
	
