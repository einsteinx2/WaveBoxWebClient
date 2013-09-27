Utils = require '../utils/utils'

class Track extends Backbone.Model
	defaults:
		itemTypeId: null
		artistId: null
		artistName: null
		albumArtistId: null
		albumArtistName: null
		albumId: null
		songName: null
		trackNumber: null
		discNumber: null
		releaseYear: null
		itemId: null
		folderId: null
		fileType: null
		duration: null
		bitrate: null
		fileSize: null
		lastModified: null
		fileName: null
		genreId: null
		genreName: null
		artId: null

	url: -> "/api/songs/#{@get("itemId")}"

	formattedDuration: ->
		if (@get "duration")?
			return Utils.formattedTimeWithSeconds(@get "duration")
		else
			null

	coverViewFields: ->
		title: @get("songName")
		subtitle: @get("artistName")
		artId: @get("artId")

module.exports = Track
