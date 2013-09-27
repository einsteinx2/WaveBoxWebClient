PageView = require '../pageView'
Artist = require '../../models/artist'
AlbumArtist = require '../../models/albumArtist'
CoverListView = require '../coverList/coverListView'
TrackListView = require '../tracklistview'

class ArtistView extends PageView
	tagName: "div"
	className: "scroll"
	template: _.template($("#template-page-artist").html())
	events:
		"click .collection-actions-play-all": "playAll"
		"click .page-artist-header": "toggleHeader"
		"click .page-artist-tab-songs": "showSongs"
		"click .page-artist-tab-albums": "showAlbums"
		"click .page-artist-tab-favorites": "showFavorites"
		"click .sprite": (e) ->
			if not @headerEnabled
				e.stopPropagation()

	initialize: (options) ->
		@contentLoaded = no
		@headerEnabled = yes
		@isAlbumArtist = options.isAlbumArtist? and options.isAlbumArtist
		if options.artistId?
			options.retrieveSongs = yes
			@artist = if @isAlbumArtist then new AlbumArtist options else new Artist options
			@listenToOnce @artist, "change", =>
				console.log @artist
				@contentLoaded = yes
				@render()
			@artist.fetch()

	render: ->
		@artistName = @artist.get(if @isAlbumArtist then "albumArtistName" else "artistName")

		# $page = ArtistView.__super__.render
		# 	leftAccessory: "sprite-back-arrow"
		# 	rightAccessory: "sprite-play-queue"
		# 	artUrl: ""
		# 	pageTitle: @artistName or ""
		# 	search: no
		# document.title = "Wave - " + (@artistName or "")


		# @$content = $page.find(".page-content")
		# 	.addClass("scroll")
		# 	.append($("#template-page-collection-actions").html())

		if @contentLoaded
			@$el.append @template
				artistName: @artistName
				counts: @artist.get("counts")
			@$content = @$el.find(".page-content")
			@$el.find(".page-artist-header").css("background-image", "url(#{wavebox.apiClient.getArtistArtUrl(@artist.get("musicBrainzId"))})")
			# @covers = new CoverListView collection: @artist.get("albums")
			# @$el.append @covers.render().el
			@showAlbums()

		this

	toggleHeader: (e) ->
		if $(e.target).hasClass("sprite") then return
		$header = @$el.find(".page-artist-header-overlay")
		opacity = if @headerEnabled then 0 else 1
		@headerEnabled = not @headerEnabled
		$header.css("opacity", opacity)

	showSongs: ->
		console.log "songs"
		view = new TrackListView collection: @artist.get("tracks")
		@$content.empty().append view.render().el
		return no

	showAlbums: ->
		console.log "albums"
		view = new CoverListView collection: @artist.get("albums")
		@$content.empty().append view.render().el
		return no

	showFavorites: ->
		console.log "favorites"
		return no

	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @artist, "change", ->
			console.log "got tracks"
			@artist.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
			if @artist.get("tracks").size() is wavebox.audioPlayer.playQueue.tracks.size()
				wavebox.audioPlayer.playAt 0
		@artist.retrieveSongs()

module.exports = ArtistView
