AlbumsDynamicBoxListView = require "./albumsdynamicboxlistview"

module.exports = Backbone.View.extend
	tagName: "div"
	filter: ""
	template: _.template($("#template-pageView").html())
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
		result = @template
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: ""
			searchBarClass: ""

		@$el.empty().append $("<div>").append(result).append @albumListing.render().el
		this
	
