TrackList = require '../collections/tracklist'

class Playlist extends Backbone.Model
	defaults:
		playlistId: null
		name: null
		count: null
		duration: null
		md5Hash: null
		lastUpdateTime: null
		tracks: null

	initialize: (options) ->
		@playlistId = if options.id? then options.id else null
		console.log "Playlist INIT called for #{@playlistId} with options:"
		console.log options

	sync: (method, model, options) ->
		if method is "read"
			console.log "Playlist SYNC called for #{@playlistId}"
			wavebox.apiClient.getPlaylist @playlistId, (success, data) =>
				if success
					hash = data.playlists[0]

					hash.tracks = new TrackList data.mediaItems
					@set hash
				else
					console.log "artistInfo!"
					console.log data

module.exports = Playlist
