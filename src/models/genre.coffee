Artists = require '../collections/artists'
Albums = require '../collections/albums'
TrackList = require '../collections/tracklist'
Folders = require '../collections/folderlist'

class Genre extends Backbone.Model
	defaults:
		GenreId: null
		GenreName: null
		Folders: null
		Artists: null
		Albums: null
		Tracks: null

	initialize: (options) ->
		if options.genreId?
			@set "GenreId", options.genreId

	pageUrl: ->
		"/genres/#{@get("GenreId")}"

	coverViewFields: ->
		title: @get "GenreName"
		artId: null

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getGenre @get("GenreId"), (success, data) ->
				if success
					hash = {}
					hash.folders = new Folders(data.folders)
					hash.artists = new Artists(data.artists)
					hash.albums = new Albums(data.albums)
					hash.tracks = new TrackList(data.songs)
					@set hash

module.exports = Genre
