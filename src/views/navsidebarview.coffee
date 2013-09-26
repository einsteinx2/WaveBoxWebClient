#    Filename: sidebarview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

SidebarSectionView = require "./navsidebarsectionview"
PlaylistsSectionView = require "./playlists/playlistsSectionView"
ServerSearchView = require "./serverSearchView"

class NavSidebarView extends Backbone.View

	el: "#left"

	initialize: ->
		@serverSearch = new ServerSearchView
		@serverSectionView = new SidebarSectionView
			items: [
				{
					itemTitle: "MyServer",
					itemClass: "Cloud sprite",
					accessoryClass: "Settings",
					href: "#"
				}
			]
		@browseSectionView = new SidebarSectionView
			title: "Browse"
			items: [
				{
					itemTitle: "Artists",
					itemClass: "sprite-music-note",
					href: "#albumartists"
				},
				{
					itemTitle: "Albums",
					itemClass: "sprite-cd",
					href: "#albums"
				},
				{
					itemTitle: "Folders",
					itemClass: "sprite-folder",
					href: "#folders"
				},
				{
					itemTitle: "Genres",
					itemClass: "sprite-folder",
					href: "#genres"
				}
			]
		@playlistSectionView = new PlaylistsSectionView
			title: "Playlists"
		@settingSectionView = new SidebarSectionView
			title: "Settings"
			items: [
				{
					itemTitle: "Settings",
					itemClass: "sprite-cog",
					href: "#settings"
				},
				{
					itemTitle: "Log out",
					itemClass: "",
					href: "#login"
				}
			]

		@listenTo(@serverSearch, "serverSearchResultsToggle", @toggleSearch)
		#@listenTo @playlistSectionView.collection, "reset", "render"
		#@playlistSectionView.collection.fetch reset: yes

	render: ->

		console.log "rendering dat navsidebarview"
		$temp = $("<div>")
		#$temp.append @serverSectionView.render().el
		$temp.append @browseSectionView.render().el
		$temp.append @playlistSectionView.render().el
		$temp.append @settingSectionView.render().el

		if !@$nav?
			@$nav = $("#nav")
		@$nav.empty().append $temp.children()

		@$el.find(".server-search-container").append(@serverSearch.render().$el)
		this

	toggleSearch: =>
		if @serverSearch.visible
			@serverSearch.hide()
			@$nav.css("-webkit-transform", "none")
		else
			@serverSearch.show()
			@$nav.css("-webkit-transform", "translateY(#{window.innerHeight}px")

module.exports = NavSidebarView
