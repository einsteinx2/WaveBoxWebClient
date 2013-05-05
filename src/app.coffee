AudioPlayer = require './utils/audioPlayer'
console.log " 1"
ApiClient = require './utils/apiClient'
console.log " 2"
ArtistsView = require './views/artistsview'
console.log " 3"
Artists = require './collections/artists'
console.log "4"

window.wavebox = {}

wavebox.apiClient = new ApiClient.ApiClient
console.log "1"
wavebox.mainView = new ArtistsView(collection: new Artists)
console.log "2"
wavebox.audioPlayer = new AudioPlayer.AudioPlayer
console.log "3"

$ ->
	wavebox.apiClient.authenticate "test", "test", (success) ->
			console.log "success? #{success}"
			wavebox.mainView.collection.fetch(reset: true)

# wavebox.Router = Backbone.Router.extend
# 	initialize: ->