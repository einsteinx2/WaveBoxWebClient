AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'

App = Backbone.Router.extend
	initialize: ->
		@audioPlayer = new AudioPlayer.AudioPlayer()
		@apiClient = new ApiClient.ApiClient()

$ ->
	app = new App()
