exports.AudioPlayer = Backbone.Model.extend
	events:
		"click .playerButtonShuffle": "shuffle"
		"click .playerButtonRepeat": "repeat"
		"click .playerButtonNext": "next"
		"click .playerButtonPrevious": "previous"
		"click .playerButtonPlayPause": "playPause"
		"songEnded": "next"

	initialize: ->
		# player properties
		@playing = false
		@volume = 1
		@muted = false

		# playlist state
		@shufflePlaylist = []
		@normalPlaylist = []
		@currentPlaylist = []
		
		# progress
		@elapsed = 0
		@duration = 0
		@downloadProgress = 1
		
		# options
		@preferredCodec = "mp3"
		@jPlayer = $("#jPlayer")

		# initialize jPlayer
		@jPlayer.jPlayer
			ready: =>
			ended: =>
				@trigger "songEnded"
			play: =>
				@playing = true
			pause: =>
				@playing = false
			progress: (e) =>
				@downloadProgress = e.jPlayer.status.seekPercent / 100
				@trigger "downloadUpdate"
			timeupdate: (e) =>
				@elapsed = e.jPlayer.status.currentTime
				@duration = e.jPlayer.status.duration
				@trigger "timeUpdate"
			volumechange: (e) =>
				@volume = e.jPlayer.options.volume
				@muted = e.jPlayer.options.muted
				@trigger "volumeChange"
			swfPath: "/swf/"
			supplied: "mp3, oga"
			solution: "html, flash"

	next: ->
		return ""

	previous: ->
		return ""

	playPause: ->
		console.log "playPause triggered"
		if not @playing then @jPlayer.jPlayer "play" else @jPlayer.jPlayer "pause"

	currentSong: ->
		if @currentPlaylist.length > 0 then currentPlaylist[0] else null

	setPlayerSong: (song, shouldPlay) ->
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

			urlObject = wavebox.apiClient.getSongUrlObject song
			@jPlayer.jPlayer "setMedia", urlObject
			@jPlayer.jPlayer "play" if shouldPlay

			# @saveToLocalStorage()
			@trigger "newSong"

		else
			console.log "unable to play\n #{song}"
			@next()


	preferredFormatForSong: (song) ->
		switch song.fileType
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