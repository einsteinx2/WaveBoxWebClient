AlbumListingViewListView = require './albumlistingviewlistview'
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
			artUrl = wavebox.apiClient.getArtUrl @album.get("artId"), 300
			albumTitle = @album.get "albumName"

			duration = 0
			tracks = @album.get "tracks"

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
			trackListView = new AlbumListingViewListView
				collection: tracks
				artUrl: artUrl
			$temp.append @template
				artUrl: artUrl or ""
				totalDuration: Utils.formattedTimeWithSeconds duration
				trackCount: tracks.size()
				artistName: @album.get("artistName") or ""
				albumName: albumTitle or ""

			$temp.append trackListView.render().el
		else
			$temp.append "Loading"
		@$el.empty().append $temp.children()
		#@$el.css "background-image", artUrl
		this


