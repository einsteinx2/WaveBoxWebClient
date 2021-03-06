SongItemView = require './songitemview'

module.exports = Backbone.View.extend
	tagName: "div"
	template: _.template($("#template-trackList").html())
	initialize: (options) ->
		@filter = ""
		if options.collection?
			@tracks = options.collection

		if options.artUrl? then @artUrl = options.artUrl else @artUrl = ""
		@animated = no
		#@collection = new Artists
		#@collection.fetch reset: true
		#@listenToOnce @collection, "reset", ->
		#	@trigger "reset"
		#
	events:
		"click .albumListingSidebar-item": ->
			console.log "should animate"
			if wavebox.isMobile()
				if not @animated
					@animated = yes
					wavebox.appController.switchPanels "right"
					main = $("#main")
					main.transition {x: -50}, 250, "linear", =>
						main.transition {x: 0}, 250, "linear"

		"click .playAll": (e) ->
			e.preventDefault()
			console.log this
			@tracks.each (track) =>
				wavebox.audioPlayer.playQueue.add track

	render: ->
		# table header
		$temp = $('<div>')
		$temp.append @template
			artUrl: @artUrl

		# table content
		$trackList = $("<table>").addClass "trackTable"
		filter = @filter.toLowerCase()
		if @tracks?
			@tracks.each (track) =>
				trackN = track.get("songName").toLowerCase()
				if trackN.indexOf(filter) >= 0
					view = new SongItemView track
					$trackList.append view.render().el
		$temp.append $trackList
		@$el.empty().append $temp.children()
		this

