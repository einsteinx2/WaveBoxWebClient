#    Filename: sidebarview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

SidebarSectionView = require "./navsidebarsectionview"
PlaylistsSectionView = require "./playlists/playlistsSectionView"

class NavSidebarView extends Backbone.View
	
	el: "#nav"

	initialize: ->
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

					#		{
					#			itemTitle: "Discover",
					#			itemClass: "Discover sprite",
					#			href: "#discover"
					#		},
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
		#@listenTo @playlistSectionView.collection, "reset", "render"
		#@playlistSectionView.collection.fetch reset: yes
	
	render: ->
		console.log "rendering dat navsidebarview"
		$temp = $("<div>")
		#$temp.append @serverSectionView.render().el
		$temp.append @browseSectionView.render().el
		$temp.append @playlistSectionView.render().el
		$temp.append @settingSectionView.render().el
		@$el.empty().append $temp.children()

module.exports = NavSidebarView
