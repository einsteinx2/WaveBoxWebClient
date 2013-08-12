Playlists = require "../../collections/playlists"
SidebarSectionView = require "../navsidebarsectionview"
PlaylistSidebarItemView = require "./playlistSidebarItemView"
CreatePlaylistSidebarItemView = require '../createPlaylistSidebarItemView'

class PlaylistSectionView extends SidebarSectionView

	initialize: (options) ->
		@options = options
		@title = options.title
		@filter = ""
		@collection = new Playlists
		@create = new CreatePlaylistSidebarItemView
		@listenToOnce @collection, "reset", =>
			@render()
		@listenTo wavebox.dragDrop, "mediaDragStart", @mediaDragStart
		@listenTo wavebox.dragDrop, "mediaDragEnd", @mediaDragEnd
		@listenTo @create.model, "changed", @newPlaylist
		@collection.fetch reset: yes

	#className: "main-scrollingContent artistsMain scroll listView"
	render: ->
		# Create the header
		@renderHeader()

		# Create the rows
		$temp = $('<div>')
		@collection.each (playlist) =>
			if playlist.get("name") isnt "jukeboxQPbjnbh2JPU5NGxhXiiQ"
				view = new PlaylistSidebarItemView model: playlist
				$temp.append view.render().el
		$temp.append @create.render().el
		@$el.append $temp.children()
		this

	newPlaylist: ->
		@listenTo @collection, "reset", @render
		@collection.fetch reset: yes
	
	mediaDragStart: =>
		@$el.append($("<div>").addClass("dropzone-callout"))

	mediaDragEnd: =>
		@$el.find(".dropzone-callout").remove()



module.exports = PlaylistSectionView
