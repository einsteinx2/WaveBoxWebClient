class ApiClient
	constructor: ->
		@API_ADDRESS = '/api'
		@SESSION_ID = localStorage.getItem "waveBoxSessionKey"
		console.log @SESSION_ID
		@itemCache = []

	cacheItem: (item) ->
		@itemCache[parseInt(item.itemId, 10)] = item

	getCachedItem: (itemId) ->
		@itemCache[parseInt(itemId, 10)]

	logOut: (callback) ->
		# Make server explicitly clear session from database
		$.ajax
			url: "#{@API_ADDRESS}/logout"
			success: (data) =>
				if not data.error?
					if callback? then callback true
				else
					if callback? then callback false, data.error
			error: (XHR, status, error) ->
				console.log "logOut failed with error code: #{JSON.stringify(XHR)}"
				if callback? then callback false
			async: true
			type: 'POST'

		# Clear web client's ID storage
		@SESSION_ID = null
		localStorage.clear()

	authenticate: (username, password, callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/login"
			data: "u=#{username}&p=#{password}"
			success: (data) =>
				if not data.error?
					@SESSION_ID = data.sessionId
					localStorage.setItem "waveBoxSessionKey", @SESSION_ID
					if callback? then callback true
				else
					if callback? then callback false, data.error
			error: (XHR, status, error) ->
				console.log "authenticate failed with error code: #{JSON.stringify(XHR)}"
				if callback? then callback false
			async: true
			type: 'POST'

	clientIsAuthenticated: (callback) ->
		if @SESSION_ID?
			console.log "Verifying sessionId"
			$.ajax
				url: "#{@API_ADDRESS}/status"
				success: (data) ->
					if data.error?
						console.log "sessionId not valid, error: #{data.error}"
						if callback? then callback false, data.error
					else
						console.log "sessionId is valid"
						if callback? then callback true
				error: (XHR, status, error) ->
					console.log "error checking session id: #{status}"
					if callback? then callback false
				async: true
				type: "POST"
		else
			if callback? then callback false

	createPlaylist: (name, callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/playlists"
			data: "action=create&name=#{encodeURIComponent(name)}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true

			error: (XHR, status, error) ->
				console.log "error getting playlist list: #{status}"
				callback false, error

	addToPlaylist: (playlistId, itemIds, callback) ->
		itemIdString = ""
		if typeof itemIds is "Array"
			# Convert the array to a comma delimited list
			_.each itemIds, (itemId, index) ->
				itemIdString += "," unless index is 0
				itemIdString += itemId
		else
			# Assume it's a single id and just use it directly
			itemIdString = itemIds

		$.ajax
			url: "#{@API_ADDRESS}/playlists/#{playlistId}"
			data: "action=add&itemIds=#{itemIdString}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.playlists
			error: (XHR, status, error) ->
				console.log "error getting playlist list: #{status}"
				callback false, error
			async: true
			type: "POST"


	getPlaylistList: (callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/playlists"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.playlists
			error: (XHR, status, error) ->
				console.log "error getting playlist list: #{status}"
				callback false, error
			async: true
			type: "POST"

	getPlaylist: (playlistId, callback) ->
		return if not playlistId?

		$.ajax
			url: "#{@API_ADDRESS}/playlists/#{playlistId}"
			success: (data) ->
				console.log "dunnit"
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting playlist: #{status}"
				callback false, error
			async: true
			type: "POST"

	getArtistList: (callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/artists"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.artists
			error: (XHR, status, error) ->
				console.log "error getting artist list: #{status}"
				callback false, error
			async: true
			type: "POST"

	getArtist: (artistId, retrieveSongs, callback) ->
		return if not artistId?

		$.ajax
			url: "#{@API_ADDRESS}/artists/#{artistId}"
			data: "includeSongs=#{retrieveSongs}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting artist: #{status}"
				callback false, error
			async: true
			type: "POST"

	getAlbumArtist: (albumArtistId, retrieveSongs, callback) ->
		return if not albumArtistId?

		$.ajax
			url: "#{@API_ADDRESS}/albumartists/#{albumArtistId}"
			data: "includeSongs=#{retrieveSongs}"
			success: (data) ->
				console.log "Retrieved album artist: " + albumArtistId
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting albumArtist: #{status}"
				callback false, error
			async: true
			type: "POST"

	getAlbumArtistList: (callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/albumartists"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.albumArtists, data.sectionPositions
			error: (XHR, status, error) ->
				console.log "error getting albumArtist list: #{status}"
				callback false, error
			async: true
			type: "POST"

	getAlbumList: (callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/albums"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.albums, data.sectionPositions
			error: (XHR, status, error) ->
				console.log "error getting artist list: #{status}"
				callback false, error
			async: true
			type: "POST"

	getAlbum: (albumId, callback) ->
		return if not albumId?

		$.ajax
			url: "#{@API_ADDRESS}/albums/#{albumId}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting album: #{status}"
				callback false, error
			async: true
			type: "POST"

	getArtistAlbums: (artistId, callback) ->
		return if not artistId?

		$.ajax
			url: "#{@API_ADDRESS}/artists/#{artistId}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					console.log "sessionId is valid"
					if callback? then callback true, data.albums, data.sectionPositions
			error: (XHR, status, error) ->
				console.log "error getting artist albums list: #{status}"
				if callback? then callback false, error
			async: true
			type: "POST"

	getGenreList: (callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/genres"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					if callback? then callback true, data.genres, data.sectionPositions
			error: (XHR, status, error) ->
				console.log "error getting genre list: #{status}"
				callback false, error
			async: true
			type: "POST"


	getSongList: (id, forItemType = "albums", callback) ->
		return if not id?

		$.ajax
			url: "#{@API_ADDRESS}/#{forItemType}/#{id}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					console.log "sessionId is valid"
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting song list: #{status}"
				if callback? then callback false, error
			async: true
			type: "POST"

	getFolder: (folderId, recursive = false, callback) ->

		url = "#{@API_ADDRESS}/folders"
		if folderId?
			url += "/#{folderId}"

		data = ""

		if recursive
			data += "recursiveMedia=1"

		$.ajax
			url: url
			data: data
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					console.log "sessionId is valid"
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting song list: #{status}"
				callback context, false, error
			async: true
			type: "POST"

	getSongUrlObject: (song, offsetSeconds) ->
		return if not song?
		urlObj = {}

		itemId = song.get "itemId"
		fileType = song.get "fileType"
		seconds = if offsetSeconds? then offsetSeconds else 0

		if fileType is 2
			urlObj.mp3 = "/api/stream/#{itemId}?seconds=#{seconds}"
		else
			urlObj.mp3 = "/api/transcode/#{itemId}?transType=MP3&transQuality=192&seconds=#{seconds}"

		if fileType is 4
			urlObj.oga = "/api/stream/#{itemId}?seconds=#{seconds}"
		else
			urlObj.oga = "/api/transcode/#{itemId}?transType=OGG&transQuality=192&seconds=#{seconds}"

		return urlObj

	getArtUrl: (artId, size) ->
		if size?
			if window.devicePixelRatio?
				size *= window.devicePixelRatio
			aSize = "?size=#{size}"
		else aSize = ""

		return "#{@API_ADDRESS}/art/#{artId}#{aSize}"

	getFanArtThumbUrl: (itemId, size) ->
		return "#{@API_ADDRESS}/fanartthumb?musicBrainzId=#{itemId}"

	lastfmSetNowPlaying: (song, callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/scrobble/#{song.itemId}"
			data: "action=NOWPLAYING"
			success: (data) ->
				if data.error?
					if data.error is "LFMNotAuthenticated"
						window.open data.authUrl
					if callback? then callback false, data.error
				else
					console.log "Successfully updated last.fm now playing"
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting song list: #{status}"
				if callback? then callback false, error
			async: true
			type: "POST"

	lastfmScrobbleTrack: (song, callback) ->
		timestamp = new Date().getTime() / 1000
		$.ajax
			url: "#{@API_ADDRESS}/scrobble"
			data: "event=#{song.itemId},#{timestamp}&action=SUBMIT"
			success: (data) ->
				if data.error?
					if data.error is "LFMNotAuthenticated"
						window.open data.authUrl
						if callback? then callback context, false, data.error
				else
					console.log "Scrobble successful"
					if callback? then callback true, data
			error: (XHR, status, error) ->
				console.log "error getting song list: #{status}"
				if callback? then callback false, error
			async: true
			type: "POST"

module.exports = ApiClient
