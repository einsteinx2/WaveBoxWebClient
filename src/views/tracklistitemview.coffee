Utils = require '../utils/utils'

class TrackListItemView extends Backbone.View
	tagName: "div"
	template: _.template($("#template-trackListItem").html())	
	initialize: ->
		@listenTo wavebox.audioPlayer, "newSong", @adjustNowPlaying

	attributes:
		"draggable": "true"

	events:
		"click": ->
			wavebox.audioPlayer.playQueue.add @model
		"dragstart": (e) ->
			wavebox.notifications.trigger "mediaDragStart"
			e.originalEvent.dataTransfer.setData("item", @model.get("itemId"))
		"dragend": ->
			wavebox.notifications.trigger "mediaDragEnd"
	render: ->
		@$el.empty().append @template
			trackNumber: @model.get "trackNumber"
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")
		this

	adjustNowPlaying: ->
		currentSong = wavebox.audioPlayer.playQueue.currentSong()
		if currentSong? and @model.get("itemId") is currentSong.get("itemId")
			@$el.addClass "nowPlaying"
		else if @$el.hasClass "nowPlaying"
			@$el.removeClass "nowPlaying"

module.exports = TrackListItemView
