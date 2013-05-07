AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'
Artists = require './collections/artists'
Router = require './router'

window.wavebox = {}

wavebox.apiClient = new ApiClient
wavebox.audioPlayer = new AudioPlayer
wavebox.router = new Router
wavebox.mainView = null
wavebox.artistsView = null
wavebox.foldersView = null

$ ->
	wavebox.apiClient.authenticate "test", "test", (success) ->
		Backbone.history.start(pushState: true)
