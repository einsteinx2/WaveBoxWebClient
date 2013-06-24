AlbumList = require '../collections/albumlist'
TrackList = require '../collections/tracklist'

module.exports = Backbone.Model.extend
	defaults:
		artId: null
		artistId: null
		artistName: null
		itemTypeId: null
		albums: null

	initialize: (options) ->
		@artistId = if options.artistId? then options.artistId else null
		@shouldRetrieveSongs = if options.retrieveSongs? then options.retrieveSongs else no

	sync: (method, model, options) ->
		if method is "read"
			console.log @shouldRetrieveSongs
			wavebox.apiClient.getArtist @artistId, @shouldRetrieveSongs, (success, data) =>
				if success
					hash = data.artists[0]
					hash.albums = new AlbumList data.albums
					hash.tracks = new TrackList data.songs
					console.log data
					console.log hash.tracks
					@set hash
					
				else
					console.log "artistInfo!"
					console.log data
	
	retrieveSongs: ->
		@shouldRetrieveSongs = yes
		@fetch()
