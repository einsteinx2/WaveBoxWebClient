Track = require '../../../models/track'
Utils = require '../../../utils/utils'

module.exports = Backbone.View.extend
	model: Track
	tagName: "div"
	className: "QueueList"
	template: _.template($("#template-playQueueItem").html())
	initialize: ->
		if wavebox.audioPlayer.playQueue.currentSong().get("itemId") is @model.get("itemId")
			@playing = yes
		else
			@playing = no

	events:
		"dblclick": "dblclick"
	render: ->
		@$el.append @template
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")

		if @playing
			@$el.addClass "nowPlaying"
		this

	dblclick: ->
		wavebox.audioPlayer.playAt wavebox.audioPlayer.playQueue.tracks.indexOf(@model)
		console.log this
