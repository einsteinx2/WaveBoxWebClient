Playlist = require '../collections/playlist'

module.exports = Backbone.Model.extend
	initialize: ->
		console.log "Readying the play queue..."
		if localStorage?
			normalModels = localStorage.getItem "wbNormalPlaylist"
			shuffleModels = localStorage.getItem "wbShufflePlaylist"
			nowPlayingIndex = localStorage.getItem "wbNowPlayingIndex"
			if shuffleModels?
				@models = new Playlist shuffleModels
				@toggleModels = new Playlist normalModels
				@shuffle = yes

			else if normalModels?
				@models = new Playlist normalModels
				@shuffle = no
			else
				@models = new Playlist
				@shuffle = no

			if nowPlayingIndex?
				@nowPlayingIndex = nowPlayingIndex
			else
				@nowPlayingIndex = 0
		else
			@models = new Playlist
			@shuffle = no
			@nowPlayingIndex = 0
