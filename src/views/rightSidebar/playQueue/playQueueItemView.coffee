Track = require '../../../models/track'
Utils = require '../../../utils/utils'

module.exports = Backbone.View.extend
	model: Track
	tagName: "div"
	className: "play-queue-item"
	template: _.template($("#template-play-queue-item").html())
	initialize: ->
		if wavebox.audioPlayer.playQueue.currentSong().get("itemId") is @model.get("itemId")
			@playing = yes
		else
			@playing = no

	events:
		"click": "dblclick"
	render: ->
		@$el.append @template
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")

		if @playing
			@$el.addClass "play-queue-now-playing"
		this

	dblclick: ->
		wavebox.audioPlayer.playAt wavebox.audioPlayer.playQueue.tracks.indexOf(@model)
		console.log this
