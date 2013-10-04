Artists = require '../collections/artists'
Albums = require '../collections/albums'
TrackList = require '../collections/tracklist'
Folders = require '../collections/folderlist'

class Genre extends Backbone.Model
	defaults:
		genreId: null
		genreName: null
		folders: null
		artists: null
		albums: null
		tracks: null

	initialize: (attributes, options) ->
		if options.genreId?
			@set "genreId", options.genreId
			@set "id", options.genreId
		@fetched = no
		@on "request", =>
			@fetched = yes

	url: ->
		"/api/genres/#{@get("genreId")}"
	pageUrl: ->
		"/genres/#{@get("genreId")}"

	coverViewFields: ->
		title: @get "genreName"
		artId: null

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
