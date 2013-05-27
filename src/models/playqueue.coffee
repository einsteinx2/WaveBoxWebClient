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
		@shuffle = no
		@nowPlayingIndex = 0
	
	add: (track) ->
		@tracks.add track
		@trigger "change"
