ArtistsView = require './views/artists/artistsview'
AlbumsView = require './views/albums/albumsview'
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
		console.log "nav artists #{Date.now()}"

		#if wavebox.appController.mainView? then wavebox.appController.mainView.undelegateEvents()
		if artistId?
			wavebox.appController.mainView.push(new ArtistView artistId: artistId)
			console.log "new view push submit #{Date.now()}"
		else
			wavebox.appController.mainView.push(new ArtistsView)
			
		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	folders: (folderId) ->

	albums: (albumId) ->
		if albumId?
			wavebox.appController.mainView.push(new AlbumListingView albumId: albumId)
		else
			wavebox.appController.mainView.push(new AlbumsView)

		if wavebox.isMobile()
			wavebox.appController.focusMainPanel()

	playlists: (playlistId) ->
		return null

	favorites: ->
		return null
	settings: ->
		return null

	home: ->
		@artists()

