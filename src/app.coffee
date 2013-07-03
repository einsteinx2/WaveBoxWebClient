AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'
Artists = require './collections/artists'
Router = require './router'
AppController = require './views/appView'
KeyboardShortcuts = require './utils/keyboardShortcuts'
DragDrop = require './utils/dragDrop'

$ ->
	if window.navigator.standalone
		$(document.body).css "top", "20px"

	window.wavebox = {}
	
	wavebox.isMobile = -> if screen.width < 769 then true else false
	wavebox.apiClient = new ApiClient
	
	wavebox.views = {}
	wavebox.views.artistsView = null
	wavebox.views.foldersView = null
	wavebox.views.pageView = _.template($("#template-pageView").html())

	wavebox.dragDrop = new DragDrop

	launch = ->
		if error? then console.log error
		wavebox.audioPlayer = new AudioPlayer
		wavebox.appController = new AppController
		wavebox.keyboardShortcuts = new KeyboardShortcuts
		wavebox.router = new Router
		
		Backbone.history.start()
		wavebox.appController.render()
	
	wavebox.apiClient.clientIsAuthenticated (answer, error) =>
		if answer is yes
			console.log "using already-valid session"
			launch()
		else
			console.log "authenticating..."
			wavebox.apiClient.authenticate "test", "test", (successful, error) =>
				if successful is yes
					console.log "success!"
					launch()
				else console.log error
