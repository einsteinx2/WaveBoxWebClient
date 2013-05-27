AlbumList = require '../collections/albumlist'

module.exports = Backbone.Model.extend
	defaults:
		artId: null
		artistId: null
		artistName: null
		itemTypeId: null
		albums: null

	initialize: (options) ->
		@artistId = if options.artistId? then options.artistId else null

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getArtist @artistId, (success, data) =>
				if success
					hash = data.albums[0]
					hash.albums = new AlbumList data.albums
					console.log hash
					@set hash
					
				else console.log data
