class exports.ApiClient
	constructor: ->
		@API_ADDRESS = '/api'
		@SESSION_ID = localStorage.getItem "waveBoxSessionKey"
		@itemCache = []

	cacheItem: (item) ->
		@itemCache[parseInt(item.itemId, 10)] = item

	getCachedItem: (itemId) ->
		@itemCache[parseInt(itemId, 10)]

	logOut: ->
		localStorage.clear()

	authenticate: (username, password, callback) ->
		console.log "Calling authenticate"

		$.ajax
			url: "#{@API_ADDRESS}/login"
			data: "u=#{username}&p=#{password}"
			success: (data) ->
				if not data.error?
					@SESSION_ID = data.sessionId
					console.log "sessionId: #{@SESSION_ID}"
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
				data: "s=#{@SESSION_ID}"
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

	getArtistList: (context, callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/artists"
			data: "s=#{@SESSION_ID}"
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

	getArtistAlbums: (artistId, context, callback) ->
		return if not artistId?

		$.ajax
			url: "#{@API_ADDRESS}/artists"
			data: "s=#{@SESSION_ID}&id=#{artistId}"
			success: (data) ->
				if data.error?
					if callback? then callback false, data.error
				else
					console.log "sessionId is valid"
					if callback? then callback true, data.albums
			error: (XHR, status, error) ->
				console.log "error getting artist albums list: #{status}"
				if callback? then callback false, error
			async: true
			type: "POST"

	getSongList: (id, forItemType = "albums", context, callback) ->
		return if not id?

		$.ajax
			url: "#{@API_ADDRESS}/#{forItemType}"
			data: "s=#{@SESSION_ID}&id=#{id}"
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
		return if not folderId?

		d = "s=#{@SESSION_ID}&id=#{id}"
		if recursive then url += "&recursiveMedia=1"

		$.ajax
			url: "#{@API_ADDRESS}/folders"
			data: d
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

	getSongUrlObject: (song) ->
		return if not song?
		urlObj = {}

		if song.fileType is 2
			urlObj.mp3 = "#{@API_ADDRESS}/stream?s=#{@SESSION_ID}&id=#{song.itemId}"
		else
			urlObj.mp3 = "#{@API_ADDRESS}/transcode?s=#{@SESSION_ID}&id=#{song.itemId}&transType=MP3&transQuality=MEDIUM"

		if song.fileType is 4
			urlObj.ogg = "#{@API_ADDRESS}/stream?s=#{@SESSION_ID}&id=#{song.itemId}"
		else 
			urlObj.ogg = "#{@API_ADDRESS}/transcode?s=#{@SESSION_ID}&id=#{song.itemId}&transType=OGG&transQuality=MEDIUM"

		return urlObj

	getArtUrl: (artId, size) ->
		if window.devicePixelRatio? and size?
			size *= window.devicePixelRatio
		asize = if size? then "&size=#{size}" else ""

		return "#{@API_ADDRESS}/art?id=#{artId}&s=#{@SESSION_ID}#{asize}"

	lastfmSetNowPlaying: (song, callback) ->
		$.ajax
			url: "#{@API_ADDRESS}/scrobble"
			data: "s=#{@SESSION_ID}&id=#{song.itemId}&action=NOWPLAYING"
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
			data: "s=#{@SESSION_ID}&event=#{song.itemId},#{timestamp}&action=SUBMIT"
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
