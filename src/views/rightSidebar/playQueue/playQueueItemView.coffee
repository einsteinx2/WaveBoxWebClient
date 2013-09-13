Track = require '../../../models/track'
Utils = require '../../../utils/utils'
ActionSheetView = require '../../actionSheet/actionSheetView'

class PlayQueueItemView extends Backbone.View
	model: Track
	tagName: "div"
	className: "play-queue-item"
	template: _.template($("#template-play-queue-item").html())
	attributes:
		"draggable": "true"

	events:
		"click": "click"
		"dragstart": "dragstart"
		"dragover": "dragover"
		"dragleave": "dragleave"
		"drop": "drop"
		"contextmenu": "rightClick"
		"touchstart": "beginPress"
		"touchmove": "touchmove"
		"touchend": "endPress"

	initialize: ->
		current = wavebox.audioPlayer.playQueue.currentSong()
		if current? and current.get("itemId") is @model.get("itemId")
			@playing = yes
		else
			@playing = no

	render: ->
		@$el.append @template
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")

		if @playing
			@$el.addClass "play-queue-now-playing"
		this

	click: ->
		wavebox.audioPlayer.playAt wavebox.audioPlayer.playQueue.tracks.indexOf(@model)
		console.log this

	dragstart: ->
		@$el.addClass "play-queue-dragged-item"
		wavebox.dragDrop.dropObject = this
		console.log "drag started: #{@model.get("songTitle")}"

	dragend: ->
		@$el.removeClass("play-queue-dragged-item").css("display", "block")

	dragover: (e) ->
		@$el.parent().find(".dragged-item").css "display", "none"
		@$el.parent().find(".play-queue-drag-position-indicator").removeClass("play-queue-drag-position-indicator")
		@$el.addClass "play-queue-drag-position-indicator"

	drop: ->
		if wavebox.dragDrop.dropObject.constructor.name isnt "PlayQueueItemView"
			console.log this.model
			wavebox.dragDrop.dropIndex = _.indexOf(wavebox.audioPlayer.playQueue.tracks.models, this.model)
			return

		item = wavebox.dragDrop.dropObject
		console.log item
		wavebox.audioPlayer.playQueue.move(item.model, _.indexOf(wavebox.audioPlayer.playQueue.tracks.models, this.model))

	showActionSheet: (origin) ->
		console.log "showing action sheet"
		sheet = new ActionSheetView
			song: @model
			items:
				[{
					itemTitle: "Clear play queue"
					action: ->
						wavebox.audioPlayer.playQueue.clear()
				},
				{
					itemTitle: "Remove"
					action: =>
						index = @el.offsetTop / 50
						console.log index
						wavebox.audioPlayer.playQueue.remove(index)
				}]
			origin: origin
		$(document.body).append sheet.render().el
		sheet.show()

	rightClick: (e) ->
		console.log e
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

module.exports = PlayQueueItemView
