TrackList = require '../collections/tracklist'

class Playlist extends Backbone.Model
	url: -> "/api/playlists/#{@get("id")}"
	pageUrl: -> "/playlists/#{@get("id")}"

	defaults:
		id: null
		name: null
		count: null
		duration: null
		md5Hash: null
		lastUpdateTime: null
		tracks: null

	initialize: (options) ->
		if options?
			@set "id", options.id or null

	coverViewFields: ->
		title: @get "playlistName"
		artId: @get "artId"

	parse: (response, options) ->
		if response.playlists? and response.mediaItems?
			hash = response.playlists[0]
			hash.tracks = new TrackList response.mediaItems
			return hash
		else
			return response

module.exports = Playlist
