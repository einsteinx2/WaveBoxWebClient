Album = require '../models/album'

module.exports = Backbone.Collection.extend
	model: Album

	sync: (method, model, options) ->
		if method is "read"
			console.log "Fetching albums list..."
			wavebox.apiClient.getAlbumList (success, data) =>
				if success
					@set data
					options.success data
				else
					options.error data
		
		else
			console.log "Method '#{method}' is undefined"
