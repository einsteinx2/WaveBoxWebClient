PageView = require '../pageView'
AlbumItemView = require './albumitemview'
Artist = require '../../models/artist'

class ArtistView extends PageView
	tagName: "div"
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
		
		$page = ArtistView.__super__.render
			leftAccessory: "BackIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: @artist.get("artistName") or ""
		document.title = "Wave - " + (@artist.get("artistName") or "")


		$content = $page.find(".content")
		$content.append($("#template-page-collection-actions").html())
		
		$covers = $("<div class='list-cover scroll'>")
		$content.append $covers

		if @contentLoaded
			@artist.get("albums").each (album, index) ->
				view = new AlbumItemView model: album
				$covers.append view.render().el

		@$el.html $page.children()
		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @artist, "change", ->
			console.log "got tracks"
			@artist.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
		@artist.retrieveSongs()

module.exports = ArtistView
