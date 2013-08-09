Genre = require '../models/genre'

class Genres extends Backbone.Collection
	model: Genre
	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getGenreList (success, data) =>
				if success
					@set data
					options.success data
				else
					options.error data

		else
			console.log "Method '#{method}' is undefined"

module.exports = Genres
