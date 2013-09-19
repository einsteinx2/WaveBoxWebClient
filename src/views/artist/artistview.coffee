PageView = require '../pageView'
Artist = require '../../models/artist'
CoverListView = require '../coverList/coverListView'

class ArtistView extends PageView
	tagName: "div"
	template: _.template($("#template-page-artist").html())
	events:
		"click .collection-actions-play-all": "playAll"

	initialize: (artistId) ->
		@contentLoaded = no
		if artistId?
			@artist = new Artist artistId
			console.log @artist
			@listenToOnce @artist, "change", =>
				console.log @artist
				@contentLoaded = yes
				@render()
			@artist.fetch()
	
	render: ->
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
