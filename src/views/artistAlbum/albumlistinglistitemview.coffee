module.exports = Backbone.View.extend
	tagName: "li"
	className: "albumListingSidebar-item"
	template: _.template($("#template-artistAlbumItem").html())
	initialize: (options) ->
		if options? then @model = options
		currentSong = wavebox.audioPlayer.playQueue.currentSong()
		if currentSong? and @model.get("itemId") is currentSong.get("itemId")
			@playing = yes
		else
			@playing = no
		@transitioning = no

	events:
		"click": ->
			wavebox.audioPlayer.playQueue.add @model
	render: ->
		@$el.html @template
			trackNumber: if not @playing then @model.get "trackNumber" else "<div></div>"
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: @model.formattedDuration()
		if @playing
			@$el.addClass "nowPlaying"
		this
