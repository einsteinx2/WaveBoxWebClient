ArtistsView = require './views/artists/artistsview'
AlbumListingView = require './views/artistAlbum/albumlistingview'
ArtistView = require './views/artist/artistview'

module.exports = Backbone.Router.extend
	routes:
		"artists(/:artistId)":		"artists"
		"folders(/:folderId)":		"folders"
		"albums(/:albumId)":		"albums"
		"playlists(/:playlistId)":	"playlists"
		"favorites":				"favorites"
		"settings":					"settings"
		"*path":					"home"

	artists: (artistId) ->
		console.log "nav artists"

		if wavebox.appController.mainView? then wavebox.appController.mainView.undelegateEvents()
		if artistId?
			wavebox.appController.mainView = new ArtistView artistId: artistId
		else
			wavebox.appController.mainView = new ArtistsView
			
		wavebox.appController.mainView.render()
		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	folders: (folderId) ->
		if wavebox.appController.mainView? then wavebox.appController.mainView.undelegateEvents()
		if folderId?
			wavebox.appController.mainView = new FoldersView
			wavebox.appController.mainView.collection.fetch(reset: true)
		return null
	
		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	albums: (albumId) ->
		if wavebox.appController.mainView? then wavebox.appController.mainView.undelegateEvents()
		if albumId?
			wavebox.appController.mainView = new AlbumListingView albumId: albumId
			wavebox.appController.mainView.render()
		else
			wavebox.appController.mainView = new AlbumsView
			wavebox.appController.mainView.render()

		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

			#wavebox.appController.mainView.collection.fetch reset: true
		wavebox.appController.mainView.render()

	playlists: (playlistId) ->
		return null

	favorites: ->
		return null
	settings: ->
		return null

	home: ->
		@artists()

