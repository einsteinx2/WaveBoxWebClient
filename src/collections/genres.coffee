Genre = require '../models/genre'

class Genres extends Backbone.Collection
	model: Genre
	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getGenreList (success, data, positions) =>
				if success
					@set data
					@positions = positions
					options.success data
				else
					options.error data

		else
			console.log "Method '#{method}' is undefined"

module.exports = Genres
