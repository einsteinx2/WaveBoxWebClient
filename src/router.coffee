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
			wavebox.mainView = new ArtistListingView artistId: artistId
			wavebox.mainView.collection.fetch reset: true
		else
			wavebox.mainView = new ArtistsView
			wavebox.mainView.collection.fetch reset: true

	folders: (folderId) ->
		if folderId?
			wavebox.mainView = new FoldersView
			wavebox.mainView.collection.fetch(reset: true)
		return null

	albums: (albumId) ->
		if albumId?
			wavebox.mainView = new AlbumListingView albumId
		else
			wavebox.mainView = new AlbumsView

			#wavebox.mainView.collection.fetch reset: true
		wavebox.mainView.render()

	playlists: (playlistId) ->
		return null

	favorites: ->
		return null
	settings: ->
		return null
	default: ->
		#@artists()
		@albums albumId: 12537
