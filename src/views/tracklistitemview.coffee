Utils = require '../utils/utils'
ActionSheetView = require "./actionSheet/actionSheetView"
Playlists = require "../collections/playlists"

class TrackListItemView extends Backbone.View

	tagName: "div"
	className: "list-track-row"
	template: _.template($("#template-track-list-row").html())
	initialize: ->
		@listenTo wavebox.audioPlayer, "newSong", @adjustNowPlaying

	attributes:
		"draggable": "true"

	events:
		"dragstart": (e) ->
			wavebox.dragDrop.mediaDragStart(@model)
		"dragend": ->
			wavebox.dragDrop.mediaDragEnd()
		"click": "click"
		"touchstart": "beginPress"
		"touchmove": "touchmove"
		"touchend": "endPress"
		"touchcancel": "endPress"
		"contextmenu": "rightClick"

	initialize: ->
		@listenTo wavebox.audioPlayer, "newSong", @adjustNowPlaying
	
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
			@$el.addClass "list-track-now-playing"
		else if @$el.hasClass "list-track-now-playing"
			@$el.removeClass "list-track-now-playing"

	click: ->
		@addToQueue()
		@highlight()
		return no

	addToQueue: =>
		wavebox.audioPlayer.playQueue.add @model
		return

	addNextToQueue: =>
		wavebox.audioPlayer.playQueue.addNext @model
		return

	addToPlaylist: =>
		# Show an action sheet with the list of playlists
		playlists = new Playlists
		playlists.fetch reset: true
		@listenToOnce playlists, "reset", =>
			items = []
			playlists.each (playlist) =>
				items.push {
					"itemTitle": playlist.get "name"
					"action": =>
						@addToServerPlaylist playlist
				}

			sheet = new ActionSheetView({
				"song": @model
				"items": items
			}).render()
			wavebox.appController.mainView.$el.append sheet.el
			sheet.show()
			return
		return

	addToServerPlaylist: (playlist) =>
		console.log "adding item #{@model.get "itemId"} to playlist #{playlist.get "id"}" 
		wavebox.apiClient.addToPlaylist playlist.get("id"), @model.get("itemId"), (success, data) ->
			console.log "added item with success #{success} and data #{data}"

	showActionSheet: (origin) ->
		console.log "showing action sheet"
		sheet = new ActionSheetView({
				song: @model
				items:
					[{
						"itemTitle": "Add to play queue"
						"action": @addToQueue
					}, {
						"itemTitle": "Play next"
						"action": @addNextToQueue
					}, {
						"itemTitle": "Add to playlist"
						"action": @addToPlaylist
					}]
				origin: origin
			}).render()
		$(document.body).append sheet.el
		sheet.show()
		return

	rightClick: (e) ->
		@showActionSheet(x: e.pageX, y: e.pageY)
		return false

	beginPress: (e) ->
		@touchStartY = e.originalEvent.pageY
		@longPressTimer = setTimeout @showActionSheet, 500

	touchmove: (e) ->
		showSheet = not (Math.abs(e.originalEvent.pageY - @touchStartY) > 10)
		console.log "showSheet: #{showSheet}"
		if not showSheet
			clearTimeout @longPressTimer

		return yes

	endPress: ->
		clearTimeout @longPressTimer

	highlight: ->
		$marker = $("<div class='list-track-row-highlight'>")
		@$el.append $marker
		$marker.transit {x: $marker.width(), opacity: 0}, ->
			$marker.remove()

module.exports = TrackListItemView
