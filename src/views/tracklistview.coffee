TrackListItemView = require "./tracklistitemview"

class TrackList extends Backbone.View
	tagName: "div"
	template: _.template($("#template-track-list").html())
	className: "list-track"

	initialize: (options) ->
		if options?
			@artId = options.artId or null

		window.a = TrackListItemView

	events:
		"click .playAll": (e) ->
			e.preventDefault()
			console.log this
			@collection.each (track) =>
				wavebox.audioPlayer.playQueue.add track

	render: ->
		$temp = $("<div>")
		
		$header = $("<div class='list-track-row list-track-header'>")
		$header.append TrackListItemView.prototype.template
			trackNumber: "#"
			songName: "Title"
			artistName: "Artist"
			duration: "Time"

		$temp.append $header

		@collection.each (track) ->
			view = new TrackListItemView model: track
			$temp.append view.render().el
		@$el.empty().append $temp.children()
		@loadArt()

		this

	loadArt: ->
		console.log this

		if @artId?
			console.log "there's an art id!"
			artUrl = wavebox.apiClient.getArtUrl @artId, $(window).width()
			art = new Image
			art.onload = =>
				@$el.find(".main-albumArt")
					.css("background-image", "url('#{artUrl}')")
					.children()
					.css("opacity", 0)
			art.src = artUrl

module.exports = TrackList
