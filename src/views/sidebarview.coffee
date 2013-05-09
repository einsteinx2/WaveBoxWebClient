#    Filename: sidebarview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

SidebarSectionView = require "./sidebarsectionview"
#SidebarPlaylistSectionView = require "./sidebarplaylistsectionview"

module.exports = Backbone.View.extend
	
	el: "#SidebarMenu"
	initialize: ->
		@browseSectionView = new SidebarSectionView
			title: "Browse"
			items: [
				{ itemTitle: "", itemClass: "Cloud sprite" },
				{ itemTitle: "Music", itemClass: "Music sprite" },
				{ itemTitle: "Discover", itemClass: "Discover sprite" },
				{ itemTitle: "Folder", itemClass: "Folder sprite" }
			]
		#@playlistSectionView = new SidebarPlaylistSectionView
		@settingSectionView = new SidebarSectionView
			title: "Setting"
			items: [
				{ itemTitle: "Airplane Mode", itemClass: "Offline sprite" },
				{ itemTitle: "Settings", itemClass: "Settings sprite" }
			]
		#@listenTo @playlistSectionView.collection, "reset", "render"
			#@playlistSectionView.collection.fetch reset: yes
	
	render: ->
		console.log "rendering sideview"
		$temp = $("<div>")
		$temp.append @browseSectionView.render().el
		#$temp.append @playlistSectionView.render.el
		$temp.append @settingSectionView.render().el
		@$el.empty().append $temp.html()
		console.log $temp.html()
		console.log @$el.html()
		this
