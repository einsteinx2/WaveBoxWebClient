ArtistsDynamicBoxListView = require "./artistsdynamicboxlistview"

module.exports = Backbone.View.extend
	el: "#main"
	filter: ""
	template: _.template($("#template-pageView").html())
	initialize: ->
		@artistListing = new ArtistsDynamicBoxListView
					
	events:
		"input .searchBar-textbox": (event) ->
			@artistListing.filter = $(event.currentTarget).val()
			@artistListing.trigger "filterChanged"
			
	render: ->
		result = @template
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			pageTitle: ""
			searchBarClass: ""

		@$el.empty().append $("<div>").append(result).append @artistListing.render().el
		this
	
