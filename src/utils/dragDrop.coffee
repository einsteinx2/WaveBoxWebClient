class DragDrop extends Backbone.Model

	initialize: ->
		@dropObject = null

	mediaDragStart: (dropObject) ->
		@dropObject = dropObject
		@trigger "mediaDragStart"

	mediaDragEnd: ->
		dropObject = null
		@trigger "mediaDragEnd"

module.exports = DragDrop

