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
		"dragenter": "dragenter"
		"dragover": "dragover"
		"drop": "drop"
		"contextmenu": "rightClick"
		"touchstart": "beginPress"
		"touchmove": "touchmove"
		"touchend": "endPress"

	render: ->
		@$el.append @template
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")
			
		setTimeout =>
			index = @$el.index()
			nowPlayingIndex = wavebox.audioPlayer.playQueue.get "nowPlayingIndex"
			if nowPlayingIndex? and index == nowPlayingIndex then @$el.addClass "play-queue-now-playing"
 		, 0

		this

	click: ->
		wavebox.audioPlayer.playAt wavebox.audioPlayer.playQueue.tracks.indexOf(@model)
		console.log this

	dragstart: (e) ->
		# Must be done on the next run loop iteration or it will affect the clone
		setTimeout =>
			wavebox.dragDrop.dropObject = this
			@$el.addClass "play-queue-dragged-item"
		, 0

	dragend: (e) ->
		# Clear all applied styles at the end of dragging
		# Note: This method is also called by AppView in it's dragend callback, otherwise this won't always be called
		@$el.removeClass("play-queue-dragged-item")
		@$el.parent().find(".play-queue-drag-position-indicator-top").removeClass("play-queue-drag-position-indicator-top")
		@$el.parent().find(".play-queue-drag-position-indicator-bottom").removeClass("play-queue-drag-position-indicator-bottom")

	dragover: (e) ->
		@$el.parent().find(".play-queue-drag-position-indicator-top").removeClass("play-queue-drag-position-indicator-top")
		@$el.parent().find(".play-queue-drag-position-indicator-bottom").removeClass("play-queue-drag-position-indicator-bottom")

		index = @$el.index()
		dragIndex = wavebox.dragDrop.dropObject.$el.index()
		playQueueCount = wavebox.audioPlayer.playQueue.tracks.length

		if index == playQueueCount - 1 and index != dragIndex 
			# Last item, add a spacer after to allow dragging past the end
			@$el.addClass "play-queue-drag-position-indicator-bottom"

		if index != dragIndex and index != dragIndex + 1
			# If this is the item being dragged or the one after the item being dragged, do nothing since it's faded out
			# For all others, just extend the top
			@$el.addClass "play-queue-drag-position-indicator-top"

	drop: ->
		if wavebox.dragDrop.dropObject.constructor.name isnt "PlayQueueItemView"
			wavebox.dragDrop.dropIndex = _.indexOf(wavebox.audioPlayer.playQueue.tracks.models, this.model)
			return

		item = wavebox.dragDrop.dropObject
		wavebox.audioPlayer.playQueue.move(item.model, _.indexOf(wavebox.audioPlayer.playQueue.tracks.models, this.model))

	showActionSheet: (origin) ->
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
