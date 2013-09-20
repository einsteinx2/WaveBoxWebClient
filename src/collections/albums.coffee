Album = require '../models/album'

class Albums extends Backbone.Collection
	model: Album

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getAlbumList (success, data, positions) =>
				if success
					@set data
					@positions = positions
					options.success data
				else
					options.error data
		
		else
			console.log "Method '#{method}' is undefined"

module.exports = Albums
