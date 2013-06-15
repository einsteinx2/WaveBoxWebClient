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
			console.log "dv click"
			@$el.find(".main-scrollingContent").addClass "listView"

		"click .AlbumSortIcon": (event) ->
			console.log "as click"
			@$el.find(".main-scrollingContent").removeClass "listView"

			
	render: ->
		result = @template
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: ""
			searchBarClass: ""

		@$el.empty().append $("<div>").append(result).append @artistListing.render().el
		this
	
