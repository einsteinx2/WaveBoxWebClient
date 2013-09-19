PageView = require '../pageView'
Artist = require '../../models/artist'
AlbumArtist = require '../../models/albumArtist'
CoverListView = require '../coverList/coverListView'

class ArtistView extends PageView
	tagName: "div"
	template: _.template($("#template-page-artist").html())
	events:
		"click .collection-actions-play-all": "playAll"

	initialize: (options) ->
		@contentLoaded = no
		@isAlbumArtist = options.isAlbumArtist? and options.isAlbumArtist
		if options.artistId?
			@artist = if @isAlbumArtist then new AlbumArtist options else new Artist options
			@listenToOnce @artist, "change", =>
				console.log @artist
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
			@$el.append @template
				artistName: @artist.get("artistName")
				counts: @artist.get("counts")
			@$el.find(".page-artist-header").css("background-image", "url('http://herpderp.me:8000?action=art&type=artist&id=#{@artist.get("musicBrainzId")}')")
			@covers = new CoverListView collection: @artist.get("albums")
			@$el.append @covers.render().el

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
