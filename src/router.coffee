ArtistsView = require './views/artistsview'

module.exports = Backbone.Router.extend
	routes:
		"artists/:artistId":		"artists"
		"folders/:folderId":		"folders"
		"playlists/:playlistId":	"playlists"
		"favorites":				"favorites"
		"settings":					"settings"
		"*path":					"default"

	artists: (artistId) ->
		wavebox.mainView = new ArtistsView
		wavebox.mainView.collection.fetch(reset: true)

	folders: (folderId) ->
		if folderId?
			wavebox.mainView = new FoldersView
			wavebox.mainView.collection.fetch(reset: true)
		return null

	playlists: (playlistId) ->
		return null

	favorites: ->
		return null
	settings: ->
		return null
	default: ->
		@artists()