AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'
Artists = require './collections/artists'
Router = require './router'
SidebarView = require './views/sidebarview'

window.wavebox = {}

wavebox.apiClient = new ApiClient
wavebox.audioPlayer = new AudioPlayer
wavebox.router = new Router
wavebox.mainView = null
wavebox.artistsView = null
wavebox.foldersView = null
wavebox.sidebarView = new SidebarView().render()

$ ->
	wavebox.apiClient.authenticate "test", "test", (success) ->
		Backbone.history.start(pushState: true)
