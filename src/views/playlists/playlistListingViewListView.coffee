PlaylistListingListItemView = require './playlistlistinglistitemview'

module.exports = Backbone.View.extend
	tagName: "div"
	className: "main-scrollingContent artistAlbumMain scroll"
	template: _.template($("#template-artistAlbum_listView").html())
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
		$trackList = $("<ul>").addClass "albumListingTrackList"
		filter = @filter.toLowerCase()
		if @tracks?
			i = 1
			@tracks.each (track) =>
				console.log "track: "
				console.log track
				songName = track.get "songName"
				if not songName?
					songName = track.get "fileName"
				trackN = songName.toLowerCase()
				track.set "position", i
				if trackN.indexOf(filter) >= 0
					view = new PlaylistListingListItemView track
					$trackList.append view.render().el
				i++
		$temp.append $trackList
		@$el.empty().append $temp.children()
		this

