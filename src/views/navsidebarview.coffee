#    Filename: sidebarview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

SidebarSectionView = require "./navsidebarsectionview"
PlaylistsSectionView = require "./playlists/PlaylistsSectionView"

module.exports = Backbone.View.extend
	
	el: "#SidebarMenu"

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
					itemClass: "Music sprite",
					href: "#artists"
				},
				{
					itemTitle: "Albums",
					itemClass: "AlbumsIcons sprite",
					href: "#albums"
				},

				{
					itemTitle: "Discover",
					itemClass: "Discover sprite",
					href: "#/discover"
				},
				{
					itemTitle: "Folder",
					itemClass: "Folder sprite",
					href: "#/folder"
				}
			]
		@playlistSectionView = new PlaylistsSectionView
			title: "Playlists"
		@settingSectionView = new SidebarSectionView
			title: "Setting"
			items: [
				{
					itemTitle: "Airplane Mode",
					itemClass: "Offline sprite",
					href: "#/airplane"
				},
				{
					itemTitle: "Settings",
					itemClass: "Settings sprite",
					href: "#/settings"
				}
			]
		#@listenTo @playlistSectionView.collection, "reset", "render"
		#@playlistSectionView.collection.fetch reset: yes
	
	render: ->
		$temp = $("<div>")
		$temp.append @serverSectionView.render().el
		$temp.append @browseSectionView.render().el
		$temp.append @playlistSectionView.render().el
		$temp.append @settingSectionView.render().el
		@$el.empty().append $temp.children()
		this

