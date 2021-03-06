Artist = require "../models/artist"

class Artists extends Backbone.Collection
	model: Artist

	sync: (method, model, options) ->
		if method is "read"
			console.log "Fetching artists list..."
			wavebox.apiClient.getArtistList (success, data, positions) =>
				if success
					@set data
					@positions = positions
					options.success data
				else
					options.error data
		else
			console.log "Method '#{method}' is undefined"

module.exports = Artists
