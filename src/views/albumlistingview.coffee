module.exports = Backbone.View.extend
	el: "#main"
	template: _.template($("#template-album_listing").html())
	name: "albumListing"
	events:
		"click .BackIcon": ->
			console.log "backicon"
			wavebox.appController.trigger "sidebarToggle"
		"click .PlaylistIcon": ->
			console.log "playlist icon"
			wavebox.appController.trigger "playlistToggle"
		"click .FilterIcon": ->
			console.log "filter icon"
			wavebox.appController.trigger "filterToggle"
	render: ->
		artUrl = wavebox.apiClient.getArtUrl 8043, 600
		console.log artUrl
		result = wavebox.views.pageView
			leftAccessoryClass: "BackIcon"
			rightAccessoryClass: "PlaylistIcon"
			artUrl: artUrl
			searchBarClass: ""
			mainContent: @template
				artUrl: artUrl
			pageTitle: "Siberia"

		@$el.html result
		@$el.find(".main-scrollingContent").addClass("albumListingMain")
		@$el.css "background-image", artUrl
		this

