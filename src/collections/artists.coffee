Artist = require "../models/artist"
ArtistView = require "../views/artistview"

module.exports = Backbone.Collection.extend
	model: Artist

	sync: (method, model, options) ->
		if method is "read"
			console.log "Fetching artists list..."
			wavebox.apiClient.getArtistList (success, data) =>
				if success
					@set data
					options.success data
				else
					options.error data
		else
			console.log "Method '#{method}' is undefined"
