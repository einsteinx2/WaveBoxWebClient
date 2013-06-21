Playlist = require '../models/playlist'

module.exports = Backbone.Collection.extend
	model: Playlist

	sync: (method, model, options) ->
		if method is "read"
			console.log "Fetching playlists list..."
			wavebox.apiClient.getPlaylistList (success, data) =>
				console.log "playlist response success: " + success + " data: "
				console.log data
				if success
					@set data
					options.success data
				else
					options.error data
		else
			console.log "Method '#{method}' is undefined"