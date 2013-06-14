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
			
	render: ->
		result = @template
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: ""
			searchBarClass: ""

		@$el.empty().append $("<div>").append(result).append @albumListing.render().el
		this
	
