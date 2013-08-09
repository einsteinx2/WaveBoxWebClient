PageView = require '../pageView'
AlbumItemView = require './albumitemview'
Artist = require '../../models/artist'
CoverListView = require '../coverList/coverListView'

class ArtistView extends PageView
	tagName: "div"
	events:
		"click .collection-actions-play-all": "playAll"

	initialize: (artistId) ->
		@contentLoaded = no
		if artistId?
			@artist = new Artist artistId
			@listenToOnce @artist, "change", =>
				@contentLoaded = yes
				@render()
			@artist.fetch()
	
	render: ->
		
		$page = ArtistView.__super__.render
			leftAccessory: "sprite-back-arrow"
			rightAccessory: "sprite-play-queue"
			artUrl: ""
			pageTitle: @artist.get("artistName") or ""
			search: no
		document.title = "Wave - " + (@artist.get("artistName") or "")


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
		@artist.retrieveSongs()

module.exports = ArtistView
