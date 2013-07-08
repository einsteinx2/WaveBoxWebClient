TrackListView = require '../tracklistview'
Playlist = require '../../models/playlist'
Utils = require '../../utils/utils'

module.exports = Backbone.View.extend
	tagName: "div"
	template: _.template($("#template-album_listing").html())
	initialize: (options) ->
		if options.playlistId?
			@contentLoaded = no
			console.log "Playlist listing view initialize"
			@playlist = new Playlist id: options.playlistId
			@listenToOnce @playlist, "change", ->
				@contentLoaded = yes
				@render()
			@playlist.fetch()

	render: ->
		$temp = $("<div>")
		if @contentLoaded
			artId = @playlist.get "artId"

			if artId?
				console.log "there's an art id!"
				artUrl = wavebox.apiClient.getArtUrl @playlist.get("artId"), 300
				art = new Image
				art.onload = =>
					@$el.find(".main-albumArt")
						.css("background-image", "url('#{artUrl}')")
						.children()
						.css("opacity", 0)
				art.src = artUrl

			playlistName = @playlist.get "name"

			duration = 0
			tracks = @playlist.get "tracks"
			totalDuration = Utils.formattedTimeWithSeconds @playlist.get "duration"
			trackCount = tracks.size()

		$temp.append wavebox.views.pageView
			leftAccessory: "MenuIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: artUrl or ""
			pageTitle: playlistName or ""
			totalDuration: totalDuration or ""
			trackCount: trackCount or ""
		document.title = if playlistName? then "Wave - #{playlistName}" else "Wave - Playlist"
			
		if @contentLoaded
			console.log "playlistListingView tracks: "
			console.log tracks
			trackListView = new TrackListView
				collection: tracks
				artUrl: artUrl
			$temp.append @template
				artUrl: artUrl or ""
				totalDuration: Utils.formattedTimeWithSeconds duration
				trackCount: tracks.size()
				artistName: ""
				albumName: playlistName or ""

			$temp.find(".albumListingContent").append trackListView.render().el
		else
			console.log "playlistListingView content not loaded"
			$temp.append "Loading"
		@$el.empty().append $temp.children()

		# HACK: in the future, we should be adding this to views
		# that need it instead of removing it from views that don't
		# need it.
		@$el.find(".DirectoryViewIcon, .AlbumSortIcon").remove()
		this
