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
		status = wavebox.audioPlayer.playQueue.get("shuffle")
		$shuffle = @$el.find(".shuffle")
		if status
			$shuffle.removeClass "off"
		else
			$shuffle.addClass "off"

	repeatChanged: ->
		repeat = wavebox.audioPlayer.playQueue.get("repeat")
		console.log repeat
		$repeat = @$el.find(".repeat")
		switch repeat
			when "one"
				$repeat.addClass("sprite-repeat-one").removeClass("off")
			when no
				$repeat.removeClass("sprite-repeat-one").addClass("off")
			when "all"
				$repeat.removeClass("sprite-repeat-one off")
