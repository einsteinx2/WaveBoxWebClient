Artists = require '../collections/artists'
Albums = require '../collections/albums'
TrackList = require '../collections/tracklist'
AlbumArtists = require '../collections/albumArtists'
ServerSearchResultsItemView = require './serverSearchResultsItemView'

class ServerSearchResultsSectionView extends Backbone.View
	tagName: "ul"
	className: "server-search-results-section"

	initialize: (options) ->
		if options?
			@type = options.type
			switch @type
				when "songs"
					@collection = new TrackList(options.collection)
				when "albums"
					@collection = new Albums(options.collection)
				when "artists"
					@collection = new Artists(options.collection)
				when "albumArtists"
					@collection = new AlbumArtists(options.collection)
				#when "videos"
			@title =
				unless @type is "albumArtists"
					@type
				else
					"artists"

	render: ->
		$temp = $("<div>")

		if @collection.size() > 0
			header = document.createElement("div")
			header.className = "server-search-results-section-header"
			header.innerText = @title.toUpperCase()
			$temp.append header

		@collection.each (item) ->
			view = new ServerSearchResultsItemView(model: item)
			$temp.append(view.render().el)
		@$el.append($temp.children())
		this

module.exports = ServerSearchResultsSectionView
