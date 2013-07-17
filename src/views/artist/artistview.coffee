PageView = require '../pageView'
AlbumItemView = require './albumitemview'
Artist = require '../../models/artist'

class ArtistView extends PageView
	tagName: "div"
	template: _.template($("#template-artistView").html())

	events:
		"click .playAll": "playAll"

	initialize: (artistId) ->
		@contentLoaded = no
		if artistId?
			@artist = new Artist artistId
			@listenToOnce @artist, "change", =>
				@contentLoaded = yes
				console.log "changed!"
				console.log @artist
				@render()
			@artist.fetch()
	
	render: ->
		@$el.html ArtistView.__super__.render
			leftAccessory: "BackIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: @artist.get("artistName") or ""
		document.title = "Wave - " + (@artist.get("artistName") or "")

		@$el.append @template()

		$temp = $("<div>")
		if @contentLoaded
			@artist.get("albums").each (album, index) ->
				view = new AlbumItemView model: album
				$temp.append view.render().el

		@$el.find(".main-scrollingContent").append $temp.children()
		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @artist, "change", ->
			console.log "got tracks"
			@artist.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
		@artist.retrieveSongs()

module.exports = ArtistView
