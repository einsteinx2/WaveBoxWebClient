TrackList = require '../collections/tracklist'

module.exports = Backbone.Model.extend
	initialize: ->
		console.log "Readying the play queue..."
#		if localStorage?
#			normalTracks = localStorage.getItem "wbNormalPlaylist"
#			shuffleTracks = localStorage.getItem "wbShufflePlaylist"
#			nowPlayingIndex = localStorage.getItem "wbNowPlayingIndex"
#			if shuffleTracks?
#				@tracks = new Playlist shuffleTracks
#				@toggleTracks = new Playlist normalTracks
#				@shuffle = yes
#
#			else if normalTracks?
#				@tracks = new Playlist normalTracks
#				@shuffle = no
#			else
#				@tracks = new Playlist
#				@shuffle = no
#
#			if nowPlayingIndex?
#				@nowPlayingIndex = nowPlayingIndex
#			else
#				@nowPlayingIndex = 0
#		else
		@tracks = new TrackList
		@set "shuffle", no
		@set "repeat", no
		@nowPlayingIndex = 0
	
	add: (track) ->
		@tracks.add track
		@trigger "change"
	
	currentSong: ->
		if @nowPlayingIndex?
			@tracks.at @nowPlayingIndex
		else
			null

	shuffleToggle: ->
		shuffle = not @get "shuffle"
		@set "shuffle", shuffle

		if shuffle
			@set "normalOrder", _.clone(@tracks)
			shuffled = _.shuffle @tracks.models
			current = @tracks.at @nowPlayingIndex
			@tracks = new TrackList(shuffled)
			@nowPlayingIndex = @tracks.indexOf current
		else
			current = @tracks.at @nowPlayingIndex
			@tracks = @get "normalOrder"
			@nowPlayingIndex = @tracks.indexOf current
			@unset "normalOrder"

		@trigger "change"
	
	repeatToggle: ->
		@set "repeat", switch(@get("repeat"))
			when no
				"one"
			when "one"
				"all"
			else
				no
