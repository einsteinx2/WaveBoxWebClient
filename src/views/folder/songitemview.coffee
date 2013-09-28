module.exports = Backbone.View.extend
	tagName: "tr"
	className: "albumListingSidebar-item"
	template: _.template($("#template-trackListItem").html())
	initialize: (options) ->
		if options? then @model = options
		@listenTo wavebox.audioPlayer, "newSong", @adjustNowPlaying

	events:
		"click": ->
			wavebox.audioPlayer.playQueue.add @model
	render: ->
		@$el.html @template
			trackNumber: if not @playing then @model.get "trackNumber" else "<div></div>"
			songName: if @model.get("songName")? then @model.get("songName") else @model.get("fileName")
			artistName: @model.get "artistName"
			duration: @model.formattedDuration()
		@adjustNowPlaying()
		this
	
	adjustNowPlaying: ->
		currentSong = wavebox.audioPlayer.playQueue.currentSong()
		if currentSong? and @model.get("itemId") is currentSong.get("itemId")
			@$el.addClass "nowPlaying"
		else if @$el.hasClass "nowPlaying"
			@$el.removeClass "nowPlaying"
