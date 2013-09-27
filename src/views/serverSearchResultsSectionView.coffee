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
			@title = options.title
			switch @title
				when "songs"
					@collection = new TrackList(options.collection)
				when "albums"
					@collection = new Albums(options.collection)
				when "artists"
					@collection = new Artists(options.collection)
				when "albumArtists"
					@collection = new AlbumArtists(options.collection)
				#when "videos"

	render: ->
		$temp = $("<div>")
		@collection.each (item) ->
			view = new ServerSearchResultsItemView(model: item)
			$temp.append(view.render().el)
		@$el.append($temp.children())
		this

module.exports = ServerSearchResultsSectionView
