Album = require '../models/album'

class Albums extends Backbone.Collection
	model: Album

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getAlbumList (success, data) =>
				if success
					@set data
					options.success data
				else
					options.error data
		
		else
			console.log "Method '#{method}' is undefined"

module.exports = Albums
