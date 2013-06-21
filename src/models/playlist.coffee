TrackList = require '../collections/tracklist'

module.exports = Backbone.Model.extend
	defaults:
		playlistId: null
		name: null
		count: null
		duration: null
		md5Hash: null
		lastUpdateTime: null
		trackList: null

	initialize: (options) ->
		@playlistId = if options.playlistId? then options.playlistId else null

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getPlaylist @playlistId, (success, data) =>
				if success
					hash = data.playlists[0]
					hash.trackList = new TrackList data.mediaItems
					@set hash
				else
					console.log "artistInfo!"
					console.log data
