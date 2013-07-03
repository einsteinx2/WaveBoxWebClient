PlayQueueItemView = require './playQueueItemView'

module.exports = Backbone.View.extend
	el: "#QueueScroller"
	initialize: ->
		console.log @model
		@listenTo @model, "change", @render
		@listenTo wavebox.audioPlayer, "newSong", @render
		@listenTo wavebox.dragDrop, "mediaDragStart", @mediaDragStart
		@listenTo wavebox.dragDrop, "mediaDragEnd", @mediaDragEnd
		
	events:
		"dragover": "dragover"
		"drop": "drop"

	render: ->
		$container = $("<div>")
		@model.tracks.each (track) ->
			view = new PlayQueueItemView model: track
			$container.append view.render().el
		
		@$el.empty().append $container.children()

	mediaDragStart: ->
		console.log @el
		@$el.append($("<div>").addClass("dropzone-callout"))

	mediaDragEnd: ->
		@$el.find(".dropzone-callout").remove()

	dragover: (e) ->
		e.preventDefault()
		console.log "Drag over play queue"
	
	drop: (e) ->
		window.b = wavebox.dragDrop.dropObject
		item = wavebox.dragDrop.dropObject
		if item?
			switch item.constructor.name
				# album needs no modifiers
				when "Folder"
					item.recursive = yes
				when "Artist"
					item.shouldRetrieveSongs = yes
				when "Track"
					wavebox.audioPlayer.playQueue.add item
					return
				else
					if item.constructor.name isnt "Album"
						console.log "invalid drop item type: #{item.constructor.name}"
						return

			@listenToOnce item, "change", =>
				item.get("tracks").each (track) ->
					wavebox.audioPlayer.playQueue.add track
			item.fetch()

