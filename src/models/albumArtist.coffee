AlbumList = require '../collections/albums'
TrackList = require '../collections/tracklist'

class AlbumArtist extends Backbone.Model
	defaults:
		artId: null
		albumArtistId: null
		albumArtistName: null
		itemTypeId: null
		albums: null
		tracks: null

	initialize: (options) ->
		artistId = if options.albumArtistId? then options.albumArtistId else options.artistId
		@albumArtistId = if artistId? then artistId else null
		@set "albumArtistId", @albumArtistId
		@shouldRetrieveSongs = if options.retrieveSongs? then options.retrieveSongs else no

	pageUrl: ->
		"/albumartists/#{@get("albumArtistId")}"

	coverViewFields: ->
		title: @get "albumArtistName"
		artId: @get "artId"
		musicBrainzId: @get "musicBrainzId"

	sync: (method, model, options) ->
		console.log "TEST sync called with method " + method
		if method is "read"
			console.log @shouldRetrieveSongs
			wavebox.apiClient.getAlbumArtist @albumArtistId, @shouldRetrieveSongs, (success, data) =>
				console.log "TEST album artist loaded"
				if success
					hash = data.artists[0]
					hash.albums = new AlbumList data.albums
					hash.tracks = new TrackList data.songs
					hash.counts = data.counts
					console.log data
					console.log hash.tracks
					@set hash
					
				else
					console.log "artistInfo!"
					console.log data
	
	retrieveSongs: ->
		@shouldRetrieveSongs = yes
		@fetch()
	
module.exports = AlbumArtist
