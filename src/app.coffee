AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'

App = Backbone.Router.extend
	initialize: ->
		@audioPlayer = new AudioPlayer.AudioPlayer()
		@apiClient = new ApiClient.ApiClient()

$ ->
	window.wavebox = new App()
	wavebox.apiClient.authenticate "test", "test", (success) ->
		console.log "success? #{success}"	
		$("body").append "Great success with the authentications!"
