Utils = require '../utils/utils'

module.exports = Backbone.Model.extend
	defaults:
		itemTypeId: null
		artistId: null
		artistName: null
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

	formattedDuration: ->
		console.log @get "duration"
		if (@get "duration")?
			return Utils.formattedTimeWithSeconds(@get "duration")
		else
			null

