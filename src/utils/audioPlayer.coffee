PlayQueue = require '../models/playqueue'

module.exports = Backbone.Model.extend
	initialize: ->
		# player properties
		@muted = false

		# playlist state
		@playQueue = new PlayQueue
		@listenTo @playQueue, "change", ->
			if @playQueue.tracks.size() is 1
				@playAt 0
		# progress
		@elapsed = 0
		@duration = 0
		@downloadProgress = 1
		
		# options
		@preferredCodec = "mp3"
		@jPlayer = $("#jPlayer")

		# initialize jPlayer
		@createJPlayerInstanceWithSupplyString "mp3, oga"

		# initialize state saving
		@playQueue.listenTo this, "timeUpdate", @playQueue.timeUpdate

		# Start the player if we were playing when we shutdown
		if localStorage.getItem("wbPlayState") is "true"
			setTimeout ( =>
				nowPlayingIndex = @playQueue.get "nowPlayingIndex"
				@playAt(nowPlayingIndex, parseFloat(localStorage.getItem("wbElapsed")))
				return
			), 1000

	playing: ->
		not @jPlayer.data().jPlayer.status.paused
		
	next: ->
		index = @playQueue.get("nowPlayingIndex") + 1
		if index > @playQueue.tracks.length - 1
			if @playQueue.get("repeat") is "all"
				index = 0
			else
				index = null

		if @playQueue.get("repeat") is "one"
			index = @playQueue.get("nowPlayingIndex")

		@playAt index

	previous: ->
		index = @playQueue.get("nowPlayingIndex") - 1
		@playAt index

	playAt: (index, secondsOffset) ->
		if index is null
			@stop()
			return

		@playQueue.set("nowPlayingIndex", index)
		song = @playQueue.tracks.at(index)
		if song?
			@setPlayerSong song, yes, secondsOffset

	playPause: ->
		console.log "playPause triggered #{@playing()}"
		if @playing()
			@jPlayer.jPlayer "pause"
		else
			@jPlayer.jPlayer "play"
		@playQueue.localSavePlayState()

	stop: ->
		@jPlayer.jPlayer "stop"

	seek: (percent) ->
		seekable = @jPlayer.data().jPlayer.status.seekPercent
		percent = if percent > seekable then seekable else percent
		@jPlayer.jPlayer "playHead", percent
		@playQueue.localSavePlayState percent

	volume: (newLevel) ->
		if not newLevel?
			return @jPlayer.jPlayer "option", "volume"

		else
			@jPlayer.jPlayer "volume", newLevel

	setPlayerSong: (song, shouldPlay, secondsOffset) ->
		if song is null
			@jPlayer.jPlayer "stop"
			@trigger "newSong"
			return

		@secondsOffset = if secondsOffset? then secondsOffset else 0

		incomingCodec = @preferredFormatForSong song
		console.log "New song type: #{incomingCodec}"

		if incomingCodec isnt "INCOMPATIBLE"
			# if jPlayer isn't init'd with the proper incoming codec, we need to re-init it
			if @preferredCodec isnt incomingCodec
				console.log "Destroying jPlayer"
				@jPlayer.jPlayer "destroy"
				@preferredCodec = incomingCodec
				supplyString = if incomingCodec is "mp3" then "mp3, oga" else "oga, mp3"
				@createJPlayerInstanceWithSupplyString supplyString

			urlObject = wavebox.apiClient.getSongUrlObject song, secondsOffset
			console.log shouldPlay
			@jPlayer.jPlayer "setMedia", urlObject
			if shouldPlay
				@jPlayer.jPlayer "play"

			# @saveToLocalStorage()
			@trigger "newSong"

		else
			console.log "unable to play\n #{song}"
			@next()
	
	createJPlayerInstanceWithSupplyString: (supplyString) ->
		that = this
		@jPlayer.jPlayer
			error: (e) -> 
				#console.log "jPlayer error event: "
				#console.log e.jPlayer
			warning: (e) -> 
				#console.log "jPlayer warning event: "
				#console.log e.jPlayer
			ready: (e) -> 
				#console.log "jPlayer ready event: "
				#console.log e.jPlayer
			ended: (e) ->
				#console.log "jPlayer ended event: "
				#console.log e.jPlayer
				that.next()
				that.trigger "songEnded"
			play: ->
				that.trigger "play"
				that.trigger "playPause"
			pause: ->
				that.trigger "pause"
				that.trigger "playPause"
			loadstart: (e) -> 
				#console.log "jPlayer loadstart event: "
				#console.log e.jPlayer
			suspend: (e) -> 
				#console.log "jPlayer suspend event: "
				#console.log e.jPlayer
			abort: (e) -> 
				#console.log "jPlayer abort event: "
				#console.log e.jPlayer
			emptied: (e) -> 
				#console.log "jPlayer empty event: "
				#console.log e.jPlayer
			stalled: (e) -> 
				#console.log "jPlayer stalled event: "
				#console.log e.jPlayer
			progress: (e) -> 
				#console.log "jPlayer progress event: "
				#console.log e.jPlayer
				that.set "downloadProgress", e.jPlayer.status.seekPercent / 100
				that.trigger "downloadUpdate"
			timeupdate: (e) ->
				#console.log "timeupdate called"
				that.set "elapsed", (e.jPlayer.status.currentTime + that.secondsOffset)
				that.set "duration", e.jPlayer.status.duration
				that.trigger "timeUpdate"
			volumechange: (e) ->
				that.muted = e.jPlayer.options.muted
				that.trigger "volumeChange"
			swfPath: "/swf/"
			supplied: supplyString
			solution: "flash, html"

	preferredFormatForSong: (song) ->
		switch song.get "fileType"
			when 1  then "oga"					# aac
			when 2  then "mp3"					# mp3
			when 3  then "oga"					# mpc
			when 4  then "oga"					# ogg
			when 5  then "oga"					# wma
			when 6  then "oga"					# alac
			when 7  then "oga"					# ape
			when 8  then "oga"					# flac
			when 9  then "oga"					# wv
			when 10 then "oga"					# mp4
			when 11 then "INCOMPATIBLE"			# mkv
			when 12 then "INCOMPATIBLE"			# avi
			when 2147483647 then "INCOMPATIBLE"	#unknown
			else "INCOMPATIBLE"
