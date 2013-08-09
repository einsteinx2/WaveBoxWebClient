Playlists = require "../../collections/playlists"
SidebarSectionView = require "../navsidebarsectionview"
PlaylistSidebarItemView = require "./playlistSidebarItemView"

class PlaylistSectionView extends SidebarSectionView

	initialize: (options) ->
		@options = options
		@title = options.title
		@filter = ""
		@collection = new Playlists
		@collection.fetch reset: true
		@listenToOnce @collection, "reset", =>
			@render()
		@listenTo wavebox.dragDrop, "mediaDragStart", @mediaDragStart
		@listenTo wavebox.dragDrop, "mediaDragEnd", @mediaDragEnd

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
		@$el.append $temp.children()
		this
	
	mediaDragStart: =>
		@$el.append($("<div>").addClass("dropzone-callout"))

	mediaDragEnd: =>
		@$el.find(".dropzone-callout").remove()



module.exports = PlaylistSectionView
