#    Filename: sidebarview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

SidebarSectionView = require "./navsidebarsectionview"
PlaylistsSectionView = require "./playlists/playlistsSectionView"

module.exports = Backbone.View.extend
	
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
					href: "#artists"
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
					itemTitle: "Airplane Mode",
					itemClass: "sprite-airplane",
					href: "#airplane"
				},
				{
					itemTitle: "Settings",
					itemClass: "sprite-cog",
					href: "#settings"
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
		#$temp.append @settingSectionView.render().el
		@$el.empty().append $temp.children()
