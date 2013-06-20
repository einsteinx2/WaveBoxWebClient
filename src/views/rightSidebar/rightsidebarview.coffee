PlayQueueView = require './playQueue/playQueueView'
MiniPlayerView = require './miniPlayer/miniPlayerView'

module.exports = Backbone.View.extend
	el: "#right"
	initialize: ->
		@miniPlayer = new MiniPlayerView
		@playQueue = new PlayQueueView model: wavebox.audioPlayer.playQueue
		@listenTo wavebox.audioPlayer.playQueue, "change:shuffle", @shuffleChanged
		@listenTo wavebox.audioPlayer.playQueue, "change:repeat", @repeatChanged

	events: ->
		"click .shuffle": ->
			wavebox.audioPlayer.playQueue.shuffleToggle()
		"click .repeat": ->
			wavebox.audioPlayer.playQueue.repeatToggle()

	render: ->
		@miniPlayer.render()
		@playQueue.render()
		this

	shuffleChanged: ->
		status = if wavebox.audioPlayer.playQueue.get("shuffle") then "on" else "off"
		@$el.find(".shuffle").text "Shuffle(#{status})"

	repeatChanged: ->
		repeat = wavebox.audioPlayer.playQueue.get("repeat")
		status = if repeat is no
			"off"
		else repeat
		@$el.find(".repeat").text "Repeat(#{status})"
