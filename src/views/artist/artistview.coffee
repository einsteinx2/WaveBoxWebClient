PageView = require '../pageView'
Artist = require '../../models/artist'
AlbumArtist = require '../../models/albumArtist'
CoverListView = require '../coverList/coverListView'

class ArtistView extends PageView
	tagName: "div"
	events:
		"click .collection-actions-play-all": "playAll"

	initialize: (options) ->
		@contentLoaded = no
		@isAlbumArtist = options.isAlbumArtist? and options.isAlbumArtist
		if options.artistId?
			@artist = if @isAlbumArtist then new AlbumArtist options else new Artist options
			@listenToOnce @artist, "change", =>
				@contentLoaded = yes
				@render()
			@artist.fetch()
	
	render: ->

		@artistName = @artist.get(if @isAlbumArtist then "albumArtistName" else "artistName")
		
		$page = ArtistView.__super__.render
			leftAccessory: "sprite-back-arrow"
			rightAccessory: "sprite-play-queue"
			artUrl: ""
			pageTitle: @artistName or ""
			search: no
		document.title = "Wave - " + (@artistName or "")


		$content = $page.find(".page-content")
		$content.addClass "scroll"
		$content.append($("#template-page-collection-actions").html())
		
		if @contentLoaded
			@covers = new CoverListView collection: @artist.get("albums")
			$content.append @covers.render().el
		@$el.html $page.children()

		this
	
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
