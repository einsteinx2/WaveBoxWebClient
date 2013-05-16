Artists = require "../collections/artists"
ArtistView = require "./artistview"

module.exports = Backbone.View.extend
	el: "#main"
	filter: ""
	initialize: ->
		@collection = new Artists
		@listenTo(@collection, "reset", @render)
		that = this
		$(".searchBar-textbox").on "input", ->
					
	events:
		"click .MenuIcon": ->
			console.log "menuicon"
			wavebox.appController.trigger "sidebarToggle"
		"click .PlaylistIcon": ->
			console.log "playlist icon"
			wavebox.appController.trigger "playlistToggle"
		"click .FilterIcon": ->
			console.log "filter icon"
			wavebox.appController.trigger "filterToggle"
		"input .searchBar-textbox": (event) ->
			@filter = $(event.currentTarget).val()
			doFilter = =>
				clearTimeout @timeout
				content = @renderMainContent()
				@$el.find(".mainContent").html content
			@timeout = setTimeout doFilter, 50

	render: ->
		start = new Date()
		result = wavebox.views.pageView
			leftAccessoryClass: "MenuIcon"
			rightAccessoryClass: "PlaylistIcon"
			pageTitle: ""
			searchBarClass: ""
			artUrl: ""
			mainContent: @renderMainContent()
		end = new Date()
		console.log "render took #{end.getTime() - start.getTime()}ms"
		@$el.html result
		@$el.find(".main-scrollingContent").addClass("artistsMain")
		this
	
	renderMainContent: ->
		$div = $('<div>')
		filter = @filter.toLowerCase()
		@collection.each (artist) =>
			artistN = artist.get("artistName").toLowerCase()
			if artistN.indexOf(filter) >= 0
				view = new ArtistView model: artist
				$div.append view.render().el
		return $div.html()

