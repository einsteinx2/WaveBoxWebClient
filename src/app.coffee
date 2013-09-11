AudioPlayer = require './utils/audioPlayer'
ApiClient = require './utils/apiClient'
Artists = require './collections/artists'
Router = require './router'
AppController = require './views/appView'
KeyboardShortcuts = require './utils/keyboardShortcuts'
DragDrop = require './utils/dragDrop'
LoginView = require './loginView'

$ ->
	if window.navigator.standalone
		$(document.body).addClass "full-screen-web-app"

	window.wavebox = {}
	
	wavebox.isMobile = -> if screen.width < 769 then true else false
	#wavebox.isMobile = -> yes
	wavebox.apiClient = new ApiClient
	wavebox.dragDrop = new DragDrop

	launch = ->
		if error? then console.log error
		wavebox.audioPlayer = new AudioPlayer
		wavebox.appController = new AppController
		wavebox.keyboardShortcuts = new KeyboardShortcuts
		wavebox.router = new Router
		
		Backbone.history.start()
		wavebox.appController.render()

	login = new LoginView
		success: launch
		error: ->
			console.log "an error happened"

	login.render()

	#wavebox.apiClient.clientIsAuthenticated (answer, error) =>
	#	if answer is yes
	#		console.log "using already-valid session"
	#		launch()
	#	else
	#		console.log "authenticating..."
	#		wavebox.apiClient.authenticate "test", "test", (successful, error) =>
	#			if successful is yes
	#				console.log "success!"
	#				launch()
	#			else console.log error
