AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'
Artists = require './collections/artists'
Router = require './router'
AppController = require './views/appView'


$ ->
	window.wavebox = {}
	
	wavebox.isMobile = -> if screen.width < 768 then true else false
	wavebox.appController = new AppController
	wavebox.apiClient = new ApiClient
	wavebox.router = new Router
	wavebox.audioPlayer = null
	
	wavebox.views = {}
	wavebox.views.artistsView = null
	wavebox.views.foldersView = null
	wavebox.views.pageView = _.template($("#template-pageView").html())

	wavebox.apiClient.authenticate "test", "test", (success) ->
		Backbone.history.start()
		wavebox.appController.render()
		wavebox.audioPlayer = new AudioPlayer
