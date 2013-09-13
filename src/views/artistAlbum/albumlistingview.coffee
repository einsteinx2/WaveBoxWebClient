PageView = require '../pageView'
TrackListView = require '../tracklistview'
TrackList = require '../../collections/tracklist'
Album = require '../../models/album'
Utils = require '../../utils/utils'

class AlbumView extends PageView
	tagName: "div"
	className: "mediaPage"
	template: _.template($("#template-page-album").html())
	initialize: (options) ->
		if options.albumId?
			@contentLoaded = no
			@album = new Album albumId: options.albumId
			@listenToOnce @album, "change", ->
				@contentLoaded = yes
				@render()
			@album.fetch()

	events:
		"click .collection-actions-play-all": "playAll"


	render: ->
		$temp = $("<div>")
		if @contentLoaded
			artId = @album.get "artId"

			if artId?
				artUrl = wavebox.apiClient.getArtUrl @album.get("artId"), 300

			albumTitle = @album.get "albumName"
			duration = 0
			tracks = @album.get("tracks")

			tracks.each (track, index, list) ->
				duration += track.get "duration"

			totalDuration = Utils.formattedTimeWithSeconds duration
			trackCount = tracks.size()

		$page = AlbumView.__super__.render
			leftAccessory: "sprite-back-arrow"
			rightAccessory: "sprite-play-queue"
			artUrl: artUrl or ""
			pageTitle: albumTitle or ""
			totalDuration: totalDuration or ""
			trackCount: trackCount or ""
		$temp.append $page.children()
		document.title = "Wave - " + (albumTitle or "")

		$content = $temp.find(".page-content")
			
		if @contentLoaded
			trackList = new TrackListView collection: tracks, artId: @album.get("artId")
			$content.append @template
				artUrl: artUrl or ""
				totalDuration: Utils.formattedTimeWithSeconds duration
				trackCount: tracks.size()
				artistName: @album.get("artistName") or ""
				albumName: albumTitle or ""
				releaseYear: @album.get("releaseYear") or ""

			$content.find(".page-album-cover").css("background-image", "url(#{artUrl})")
			console.log @album

			$content.append(trackList.render().el)
			$content.addClass "scroll"
			if wavebox.isMobile()
				trackList.$el.css "top", "#{screen.width}px"
		else
			$content.append "Loading"

		@$el.empty().append $temp.children()

		# HACK: in the future, we should be adding this to views
		# that need it instead of removing it from views that don't
		# need it.
		@$el.find(".DirectoryViewIcon, .AlbumSortIcon").remove()
		this

	playAll: (e) ->
		e.preventDefault()
		@album.get("tracks").each (track) ->
			wavebox.audioPlayer.playQueue.add track
		if @album.get("tracks").size() is wavebox.audioPlayer.playQueue.tracks.size()
			wavebox.audioPlayer.playAt 0



module.exports = AlbumView
