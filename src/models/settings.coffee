class Settings extends Backbone.Model
	url: "/api/settings"
	initialize: ->

	parse: (response, options) ->
		hash = response.settings

		# tack the error onto the settings hash
		hash.error = response.error

		return hash



module.exports = Settings

