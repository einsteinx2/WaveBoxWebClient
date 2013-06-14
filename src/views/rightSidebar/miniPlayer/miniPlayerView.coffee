Utils = require '../../../utils/utils'

module.exports = Backbone.View.extend
	el: "#MiniPlayer"
	template: _.template($("#template-miniPlayer").html())
	events:
		"click #PlayBtn": "playButtonAction"
		"click .PlayerDisplay": "seek"
		#"click .PlayerDisplaySongTimeLeft": "switchElapsedMode"

	initialize: ->
		@elapsedMode = "timeElapsed"
		@listenTo wavebox.audioPlayer, "newSong", @render
		@listenTo wavebox.audioPlayer, "timeUpdate", @timeUpdate
		@listenTo wavebox.audioPlayer, "playPause", @playButtonUpdate

	render: ->
		song = wavebox.audioPlayer.playQueue.currentSong()
		temp = null
		if song?
			temp = @template
				songName: song.get "songName"
				artistName: song.get "artistName"
				duration: song.formattedDuration()
		else
			temp = @template
				songName: ""
				artistName: ""
				duration: ""
		@$el.empty().append temp

		@playerWidth = @$el.find(".PlayerDisplay").first().width()
		@playMarker = @$el.find(".PlayMarker").first()
		@elapsedTime = @$el.find(".PlayerDisplaySongTimeLeft").first()

		if not song?
			@playMarker.hide()
	playButtonAction: ->
		console.log "playBtn"
		wavebox.audioPlayer.playPause()

	playButtonUpdate: ->
		if wavebox.audioPlayer.playing()
			$("#PlayBtn").removeClass("Play").addClass("Pause")
		else
			$("#PlayBtn").removeClass("Pause").addClass("Play")
	
	timeUpdate: ->
		@updateElapsedTime()
		@updatePlayMarker()

	switchElapsedMode: ->
		console.log "clicked"
		@elapsedMode = switch @elapsedMode
			when "timeLeft"
				"timeElapsed"
			when "timeElapsed"
				"timeLeft"
			else
				"timeLeft"
		@updateElapsedTime()
		
	updateElapsedTime: ->
		duration = wavebox.audioPlayer.playQueue.currentSong().get "duration"
		elapsed = wavebox.audioPlayer.get "elapsed"
		elapsedUpdate =
			if @elapsedMode is "timeLeft"
				Utils.formattedTimeWithSeconds duration - elapsed
			else
				Utils.formattedTimeWithSeconds elapsed
		@elapsedTime.text elapsedUpdate
	
	updatePlayMarker: ->
		duration = wavebox.audioPlayer.playQueue.currentSong().get "duration"
		elapsed = wavebox.audioPlayer.get "elapsed"
		@playMarker.css "left", Math.round((elapsed / duration) * @playerWidth)

	seek: (e) ->
		percent = (e.pageX - $(".PlayerDisplay").offset().left) / $(".PlayerDisplay").width()
		percent = percent * 100
		console.log "seek percent: " + percent
		wavebox.audioPlayer.seek percent


