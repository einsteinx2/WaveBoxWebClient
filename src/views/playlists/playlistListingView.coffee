TrackListView = require '../tracklistview'
Playlist = require '../../models/playlist'
Utils = require '../../utils/utils'
PageView = require '../pageView'

class PlaylistListingView extends PageView
	tagName: "div"
	className: "mediaPage"
	# should the name of this template be changed?
	template: _.template($("#template-page-album").html())

	events:
		"click .collection-actions-play-all": "playAll"

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

		$temp = PlaylistListingView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			artUrl: artUrl or ""
			pageTitle: playlistName or ""
			totalDuration: totalDuration or ""
			trackCount: trackCount or ""

		$content = $temp.find('.page-content')
		if @contentLoaded
			console.log "playlistListingView tracks: "
			console.log tracks
			trackListView = new TrackListView
				collection: tracks
				artUrl: artUrl
			$content.append @template
				artUrl: artUrl or ""
				totalDuration: Utils.formattedTimeWithSeconds duration
				trackCount: tracks.size()
				artistName: ""
				albumName: playlistName or ""

			$content.append trackListView.render().el
			$content.addClass "scroll"
		else
			console.log "playlistListingView content not loaded"
			$temp.append "Loading"
		@$el.empty().append $temp.children()

		this

	playAll: (e) ->
		e.preventDefault()
		@playlist.get("tracks").each (track) ->
			wavebox.audioPlayer.playQueue.add track

module.exports = PlaylistListingView
