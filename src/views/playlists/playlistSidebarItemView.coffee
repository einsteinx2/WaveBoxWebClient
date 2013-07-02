NavSidebarItemView = require '../navsidebaritemview'

module.exports = class extends NavSidebarItemView
	events:
		"dragover": (e) ->
			e.preventDefault()
			@$el.children().first().addClass "playlistDragOver"
			console.log this

		"dragleave": (e) ->
			@$el.children().first().removeClass "playlistDragOver"

		"drop": (e) ->
			@$el.children().first().removeClass "playlistDragOver"
			item = e.originalEvent.dataTransfer.getData("item")
			wavebox.apiClient.addToPlaylist @model.get("id"), [ item ], =>
				# remove loading spinner and stuff
			wavebox.notifications.trigger "mediaDragEnd"
	render: ->
		@model.set "href", "#playlists/#{@model.get "id"}"
		@model.set
			"itemTitle": @model.get "name"
			"itemClass": "Playlists sprite"
		super
		this
