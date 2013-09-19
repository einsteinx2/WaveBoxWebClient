PageView = require '../pageView'
AlbumArtist = require '../../models/albumArtist'
CoverListView = require '../coverList/coverListView'

class AlbumArtistView extends PageView
	tagName: "div"
	events:
		"click .collection-actions-play-all": "playAll"

	initialize: (albumArtistId) ->
		@contentLoaded = no
		if albumArtistId?
			@albumArtist = new AlbumArtist albumArtistId
			@listenToOnce @albumArtist, "change", =>
				@contentLoaded = yes
				@render()
			@albumArtist.fetch()
	
	render: ->
		
		$page = AlbumArtistView.__super__.render
			leftAccessory: "sprite-back-arrow"
			rightAccessory: "sprite-play-queue"
			artUrl: ""
			pageTitle: @albumArtist.get("artistName") or ""
			search: no
		document.title = "Wave - " + (@albumArtist.get("artistName") or "")


		$content = $page.find(".page-content")
		$content.addClass "scroll"
		$content.append($("#template-page-collection-actions").html())
		
		console.log "TEST albums: " + @albumArtist.get("albums")
		if @contentLoaded
			@covers = new CoverListView collection: @albumArtist.get("albums")
			$content.append @covers.render().el
		@$el.html $page.children()

		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @albumArtist, "change", ->
			console.log "got tracks"
			@albumArtist.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
			if @albumArtist.get("tracks").size() is wavebox.audioPlayer.playQueue.tracks.size()
				wavebox.audioPlayer.playAt 0
		@albumArtist.retrieveSongs()

module.exports = AlbumArtistView
