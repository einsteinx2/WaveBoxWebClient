TrackList = require '../collections/tracklist'

class Album extends Backbone.Model
	defaults:
		albumId: null
		albumName: null
		artId: null
		artistId: null
		artistName: null
		itemTypeId: null
		releaseYear: null
		tracks: null
	
	initialize: (options) ->
		@albumId = options.albumId

	pageUrl: ->
		"/albums/#{@get("albumId")}"

	coverViewFields: ->
		title: @get "albumName"
		artist: @get "artistName"
		artId: @get "artId"
	
	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getAlbum @albumId, (success, data) =>
				if success
					album = data.albums[0]
					# should this be in parse()?
					@set
						albumId: album.albumId
						albumName: album.albumName
						artId: album.artId
						artistId: album.artistId
						artistName: album.artistName
						itemTypeId: album.itemTypeId
						releaseYear: album.releaseYear
						tracks: new TrackList data.songs, comparator: "trackNumber"

module.exports = Album
