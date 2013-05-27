PlayQueueView = require './playQueue/playQueueView'

module.exports = Backbone.View.extend
	el: "#right"
	initialize: ->
		@playQueueView = new PlayQueueView wavebox.audioPlayer.playQueue

	render: ->
		this
