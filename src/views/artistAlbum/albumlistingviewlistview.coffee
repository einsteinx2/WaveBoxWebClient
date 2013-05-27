AlbumListingListItemView = require './albumlistinglistitemview'

module.exports = Backbone.View.extend
	tagName: "div"
	className: "main-scrollingContent artistAlbumMain scroll"
	template: _.template($("#template-artistAlbum_listView").html())
	initialize: (options) ->
		@filter = ""
		if options.collection?
			@tracks = options.collection

		if options.artUrl? then @artUrl = options.artUrl else @artUrl = ""
		#@collection = new Artists
		#@collection.fetch reset: true
		#@listenToOnce @collection, "reset", ->
		#	@trigger "reset"
	render: ->
		# table header
		$temp = $('<div>')
		$temp.append @template
			artUrl: @artUrl

		# table content
		$trackList = $("<ul>").addClass "albumListingTrackList"
		filter = @filter.toLowerCase()
		if @tracks?
			@tracks.each (track) =>
				trackN = track.get("songName").toLowerCase()
				if trackN.indexOf(filter) >= 0
					view = new AlbumListingListItemView track
					$trackList.append view.render().el
		$temp.append $trackList
		@$el.empty().append $temp.children()
		this

