Playlists = require "../../collections/playlists"
SidebarSectionView = require "../navsidebarsectionview"
PlaylistSidebarItemView = require "./playlistSidebarItemView"

module.exports = class extends SidebarSectionView

	initialize: (options) ->
		@options = options
		@title = options.title
		console.log "options.title: #{options.title}  @title: #{@title}"
		@filter = ""
		@collection = new Playlists
		@collection.fetch reset: true
		@listenToOnce @collection, "reset", =>
			@render()

	#className: "main-scrollingContent artistsMain scroll listView"
	render: ->
		# Create the header
		@renderHeader()

		# Create the rows
		$temp = $('<div>')
		@collection.each (playlist) =>
			view = new PlaylistSidebarItemView model: playlist
			view.parent = this
			$temp.append view.render().el
		@$el.append $temp.children()
		this