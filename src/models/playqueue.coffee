TrackList = require '../collections/tracklist'

class PlayQueue extends Backbone.Model
	initialize: ->
		console.log "Readying the play queue..."
		if localStorage?
			normalTracks = JSON.parse(localStorage.getItem("wbNormalTracks"))
			shuffleTracks = JSON.parse(localStorage.getItem "wbShuffleTracks")
			nowPlayingIndex = parseInt(localStorage.getItem("wbNowPlayingIndex"))
			if shuffleTracks?
				@tracks = new TrackList shuffleTracks
				@toggleTracks = new TrackList normalTracks
				@shuffle = yes

			else if normalTracks?
				@tracks = new TrackList normalTracks
				@shuffle = no
			else
				@tracks = new TrackList
				@shuffle = no

			if nowPlayingIndex?
				@set("nowPlayingIndex", nowPlayingIndex)
			else
				@set("nowPlayingIndex", 0)
		else
			@tracks = new TrackList
			@set "shuffle", no
			@set "repeat", no
			@set("nowPlayingIndex", 0)
		
		console.log "REGISTERING"
		@on "change", @localSave
	
	add: (track, at = undefined) ->
		@tracks.add track, at: at
		@trigger "change"

	addNext: (track) ->
		@tracks.add track, {at: @get("nowPlayingIndex") + 1}
		@trigger "change"

	move: (track, toIndex) ->
		oldIndex = _.indexOf(@tracks.models, track)
		if @get("nowPlayingIndex") is oldIndex
			@set("nowPlayingIndex", toIndex)
		console.log oldIndex, toIndex
		@tracks.models.splice(toIndex, 0, @tracks.models.splice(oldIndex, 1)[0])
		console.log "moved!"
		@trigger "change"
	
	clear: =>
		@tracks = new TrackList
		@unset("nowPlayingIndex")
		wavebox.audioPlayer.setPlayerSong null
		@trigger "change"
	
	currentSong: ->
		if @get("nowPlayingIndex")?
			@tracks.at @get("nowPlayingIndex")
		else
			null

	shuffleToggle: ->
		shuffle = not @get "shuffle"
		@set "shuffle", shuffle

		if shuffle
			@set "normalOrder", _.clone(@tracks)
			shuffled = _.shuffle @tracks.models
			current = @tracks.at @get("nowPlayingIndex")
			@tracks = new TrackList(shuffled)
			@set("nowPlayingIndex", @tracks.indexOf current)
		else
			current = @tracks.at @get("nowPlayingIndex")
			@tracks = @get "normalOrder"
			@set("nowPlayingIndex", @tracks.indexOf current)
			@unset "normalOrder"

		@trigger "change"
	
	repeatToggle: ->
		@set "repeat", switch(@get("repeat"))
			when no
				"one"
			when "one"
				"all"
			else
				no

	localSave: ->
		if @shuffle
			localStorage.setItem "wbNormalTracks", JSON.stringify(@get("normalOrder"))
			localStorage.setItem "wbShuffleTracks", JSON.stringify(@tracks)
			localStorage.setItem "wbNowPlayingIndex", @get("nowPlayingIndex")
		else
			localStorage.clear "wbShuffleTracks"
			localStorage.setItem "wbNormalTracks", JSON.stringify(@tracks)
			localStorage.setItem "wbNowPlayingIndex", @get("nowPlayingIndex")

module.exports = PlayQueue
