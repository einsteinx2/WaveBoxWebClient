ArtistsView = require './views/artists/artistsview'
ArtistView = require './views/artist/artistview'
AlbumsView = require './views/albums/albumsview'
AlbumListingView = require './views/artistAlbum/albumlistingview'
GenresView = require './views/genresView'
FolderView = require './views/folder/folderview'
PlaylistListingView = require './views/playlists/playlistListingView'

module.exports = Backbone.Router.extend
	routes:
		"artists(/:artistId)":		"artists"
		"folders(/:folderId)":		"folders"
		"albums(/:albumId)":		"albums"
		"genres(/:genreId)":		"genres"
		"playlists/:playlistId":	"playlists"
		"favorites":				"favorites"
		"settings":					"settings"
		"*path":					"home"

	artists: (artistId) ->
		@sendSelectionNotification "Artists"

		console.log "nav artists #{Date.now()}"

		#if wavebox.appController.mainView? then wavebox.appController.mainView.undelegateEvents()
		if artistId?
			wavebox.appController.mainView.push(new ArtistView artistId: artistId)
			console.log "new view push submit #{Date.now()}"
		else
			wavebox.appController.mainView.push(new ArtistsView)
			
		if wavebox.isMobile()
			wavebox.appController.panels.focusMain()

	folders: (folderId) ->
		@sendSelectionNotification "Folders"
		if folderId?
			wavebox.appController.mainView.push(new FolderView(folderId: folderId, isSubFolder: yes))
		else
			wavebox.appController.mainView.push(new FolderView)

		if wavebox.isMobile()
			wavebox.appController.panels.focusMain()

	albums: (albumId) ->
		@sendSelectionNotification "Albums"
		if albumId?
			wavebox.appController.mainView.push(new AlbumListingView albumId: albumId)
		else
			wavebox.appController.mainView.push(new AlbumsView)

		if wavebox.isMobile()
			wavebox.appController.panels.focusMain()

	genres: (genreId) ->
		@sendSelectionNotification "Genres"
		console.log genreId
		if genreId?
			wavebox.appController.mainView.push(new ArtistsView genreId: genreId)
		else
			wavebox.appController.mainView.push(new GenresView)

		if wavebox.isMobile()
			wavebox.appController.panels.focusMain()

	playlists: (playlistId) ->
		@sendSelectionNotification "playlist #{playlistId}"
		console.log "router playlists for id: #{playlistId}"
		if playlistId?
			wavebox.appController.mainView.push(new PlaylistListingView playlistId: playlistId)

		if wavebox.isMobile()
			wavebox.appController.panels.focusMain()

	favorites: ->
		return null
	settings: ->
		return null

	home: ->
		@artists()

	sendSelectionNotification: (name) ->
		wavebox.appController.trigger "sidebarItemSelected", name
		
		# Hack for first page load
		setTimeout(->
			wavebox.appController.trigger "sidebarItemSelected", name 
			return
		,1000)

