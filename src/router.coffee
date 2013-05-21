ArtistsView = require './views/artists/artistsview'
AlbumListingView = require './views/artistAlbum/albumlistingview'

module.exports = Backbone.Router.extend
	routes:
		"artists(/:artistId)":		"artists"
		"folders(/:folderId)":		"folders"
		"albums(/:albumId)":		"albums"
		"playlists(/:playlistId)":	"playlists"
		"favorites":				"favorites"
		"settings":					"settings"
		"*path":					"default"

	artists: (artistId) ->
		if artistId?
			wavebox.appController.mainView = new ArtistListingView artistId: artistId
		else
			wavebox.appController.mainView = new ArtistsView
			
		wavebox.appController.mainView.render()
		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	folders: (folderId) ->
		if folderId?
			wavebox.appController.mainView = new FoldersView
			wavebox.appController.mainView.collection.fetch(reset: true)
		return null
	
		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	albums: (albumId) ->
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
	default: ->
		#@artists()
		@albums 8050
