TrackList = require '../collections/tracklist'

module.exports = Backbone.Model.extend
	defaults:
		albumId: null
		albumName: null
		artId: null
		artistId: null
		itemTypeId: null
		releaseYear: null
		tracks: null
	
	initialize: (options) ->
		@albumId = options.albumId
	
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
						itemTypeId: album.itemTypeId
						releaseYear: album.releaseYear
						tracks: new TrackList data.songs
