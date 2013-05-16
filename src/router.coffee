ArtistsView = require './views/artistsview'
AlbumListingView = require './views/albumlistingview'

module.exports = Backbone.Router.extend
	routes:
		"artists/:artistId":		"artists"
		"folders/:folderId":		"folders"
		"albums/:albumId":			"albums"
		"playlists/:playlistId":	"playlists"
		"favorites":				"favorites"
		"settings":					"settings"
		"*path":					"default"

	artists: (artistId) ->
		if artistId?
			wavebox.appController.mainView = new ArtistListingView artistId: artistId
			wavebox.appController.mainView.collection.fetch reset: true
		else
			wavebox.appController.mainView = new ArtistsView
			wavebox.appController.mainView.collection.fetch reset: true

	folders: (folderId) ->
		if folderId?
			wavebox.appController.mainView = new FoldersView
			wavebox.appController.mainView.collection.fetch(reset: true)
		return null

	albums: (albumId) ->
		if albumId?
			wavebox.appController.mainView = new AlbumListingView albumId
		else
			wavebox.appController.mainView = new AlbumsView

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
		@albums albumId: 12537
