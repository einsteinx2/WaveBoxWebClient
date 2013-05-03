AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'

App = Backbone.Router.extend
	initialize: ->
		@audioPlayer = new AudioPlayer.AudioPlayer()
		@apiClient = new ApiClient.ApiClient()

$ ->
	app = new App()
	app.apiClient.authenticate "test", "test", this, (success) ->
		console.log "success? #{success}"	
