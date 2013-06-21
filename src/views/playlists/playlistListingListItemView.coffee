module.exports = Backbone.View.extend
	tagName: "li"
	className: "albumListingSidebar-item"
	template: _.template($("#template-artistAlbumItem").html())
	initialize: (options) ->
		if options? then @model = options
		@listenTo wavebox.audioPlayer, "newSong", @adjustNowPlaying

	events:
		"click": ->
			wavebox.audioPlayer.playQueue.add @model
	render: ->
		@$el.html @template
			trackNumber: if not @playing then @model.get "position" else "<div></div>"
			songName: @model.get "songName"
			artistName: @model.get "artistName" or ""
			duration: @model.formattedDuration()
		@adjustNowPlaying()
		this
	
	adjustNowPlaying: ->
		currentSong = wavebox.audioPlayer.playQueue.currentSong()
		if currentSong? and @model.get("itemId") is currentSong.get("itemId")
			@$el.addClass "nowPlaying"
		else if @$el.hasClass "nowPlaying"
			@$el.removeClass "nowPlaying"
