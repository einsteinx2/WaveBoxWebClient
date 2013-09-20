AlbumArtist = require "../models/albumArtist"

class AlbumArtists extends Backbone.Collection
	model: AlbumArtist

	sync: (method, model, options) ->
		if method is "read"
			console.log "Fetching albumArtists list..."
			wavebox.apiClient.getAlbumArtistList (success, data, positions) =>
				if success
					@set data
					@positions = positions
					options.success data
				else
					options.error data
		else
			console.log "Method '#{method}' is undefined"

module.exports = AlbumArtists
