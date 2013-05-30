PlayQueue = require '../models/playqueue'

module.exports = Backbone.Model.extend
	initialize: ->
		# player properties
		@volume = 1
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

	playing: ->
		not @jPlayer.data().jPlayer.status.paused
		
	next: ->
		index = @playQueue.nowPlayingIndex + 1
		@playQueue.nowPlayingIndex = index
		@playAt index

	previous: ->
		index = @playQueue.nowPlayingIndex - 1
		@playQueue.nowPlayingIndex = index
		@playAt index

	playAt: (index) ->
		@playQueue.nowPlayingIndex = index
		song = @playQueue.tracks.at(index)
		if song?
			@setPlayerSong song, yes

	playPause: ->
		console.log "playPause triggered #{@playing()}"
		if @playing()
			@jPlayer.jPlayer "pause"
		else
			@jPlayer.jPlayer "play"

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
			ready: ->
			ended: ->
				that.next()
				that.trigger "songEnded"
			play: ->
			pause: ->
			progress: (e) ->
				that.set "downloadProgress", e.jPlayer.status.seekPercent / 100
				that.trigger "downloadUpdate"
			timeupdate: (e) ->
				that.set "elapsed", e.jPlayer.status.currentTime
				that.set "duration", e.jPlayer.status.duration
				that.trigger "timeUpdate"
			volumechange: (e) ->
				that.volume = e.jPlayer.options.volume
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
