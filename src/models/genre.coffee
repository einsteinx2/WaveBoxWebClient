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

	initialize: (attributes, options) ->
		if options.genreId?
			@set "GenreId", options.genreId
			@set "id", options.genreId
		@fetched = no
		@on "request", =>
			@fetched = yes

	url: ->
		"/api/genres/#{@get("GenreId")}"
	pageUrl: ->
		"/genres/#{@get("GenreId")}"

	coverViewFields: ->
		return title: @get "GenreName", artId: null

	parse: (response, options) ->
		hash = {}
		if @fetched
			hash.folders = new Folders(response.folders)
			hash.artists = new Artists(response.artists)
			hash.albums = new Albums(response.albums)
			hash.tracks = new TrackList(response.songs)
		else
			hash = response

		return hash

module.exports = Genre
