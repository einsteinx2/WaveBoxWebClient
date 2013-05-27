Track = require '../../../models/track'
Utils = require '../../../utils/utils'

module.exports = Backbone.View.extend
	model: Track
	tagName: "div"
	className: "QueueList"
	template: _.template($("#template-playQueueItem").html())
	events:
		"dblclick": "dblclick"
	render: ->
		@$el.append @template
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: Utils.formattedTimeWithSeconds(@model.get "duration")
		this

	dblclick: ->
		wavebox.audioPlayer.playAt wavebox.audioPlayer.playQueue.tracks.indexOf(@model)
		console.log this
