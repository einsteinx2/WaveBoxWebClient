PlayQueueItemView = require './playQueueItemView'

module.exports = Backbone.View.extend
	el: "#play-queue"
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

			addIndex = wavebox.dragDrop.dropIndex
			console.log "addIndex: #{addIndex}"
			@listenToOnce item, "change", =>
				item.get("tracks").each (track) ->
					wavebox.audioPlayer.playQueue.add track, addIndex
					addIndex += 1
			item.fetch()

