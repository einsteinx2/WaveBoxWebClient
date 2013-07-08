TrackListView = require '../tracklistview'
TrackList = require '../../collections/tracklist'
Album = require '../../models/album'
Utils = require '../../utils/utils'

module.exports = Backbone.View.extend
	tagName: "div"
	template: _.template($("#template-album_listing").html())
	initialize: (options) ->
		if options.albumId?
			@contentLoaded = no
			@album = new Album albumId: options.albumId
			@listenToOnce @album, "change", ->
				@contentLoaded = yes
				@render()
			@album.fetch()

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

		$temp.append wavebox.views.pageView
			leftAccessory: "BackIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: artUrl or ""
			pageTitle: albumTitle or ""
			totalDuration: totalDuration or ""
			trackCount: trackCount or ""
			
		if @contentLoaded
			trackList = new TrackListView collection: tracks, artId: @album.get("artId")
			$temp.append @template
				artUrl: artUrl or ""
				totalDuration: Utils.formattedTimeWithSeconds duration
				trackCount: tracks.size()
				artistName: @album.get("artistName") or ""
				albumName: albumTitle or ""

			$contentArea = $temp.find(".albumListingContent").first()
			$contentArea.append trackList.render().el
			if wavebox.isMobile()
				$contentArea.addClass "scroll"
			else
				trackList.$el.addClass "scroll"
		else
			$temp.append "Loading"

		@$el.empty().append $temp.children()

		# HACK: in the future, we should be adding this to views
		# that need it instead of removing it from views that don't
		# need it.
		@$el.find(".DirectoryViewIcon, .AlbumSortIcon").remove()
		this


