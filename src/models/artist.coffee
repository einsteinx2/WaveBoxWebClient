AlbumList = require '../collections/albums'
TrackList = require '../collections/tracklist'

class Artist extends Backbone.Model
	defaults:
		artId: null
		artistId: null
		artistName: null
		itemTypeId: null
		albums: null
		tracks: null
		counts: null
		musicBrainzId: null

	initialize: (options) ->
		@artistId = if options.artistId? then options.artistId else null
		@shouldRetrieveSongs = if options.retrieveSongs? then options.retrieveSongs else no

	pageUrl: ->
		"/artists/#{@get("artistId")}"

	coverViewFields: ->
		title: @get "artistName"
		artId: @get "artId"
		musicBrainzId: @get "musicBrainzId"

	sync: (method, model, options) ->
		if method is "read"
			console.log "ARTISTID: #{@artistId}"
			console.log @shouldRetrieveSongs
			wavebox.apiClient.getArtist @artistId, @shouldRetrieveSongs, (success, data) =>
				if success
					hash = data.artists[0]
					hash.albums = new AlbumList data.albums
					hash.tracks = new TrackList data.songs
					hash.counts = data.counts
					@set hash
					
	
	retrieveSongs: ->
		@shouldRetrieveSongs = yes
		@fetch()
	
module.exports = Artist
