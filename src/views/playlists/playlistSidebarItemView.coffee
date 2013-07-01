NavSidebarItemView = require '../navsidebaritemview'

module.exports = class extends NavSidebarItemView
	render: ->
		@model.set "href", "#playlists/#{@model.get "id"}"
		@model.set "itemTitle", @model.get "name"
		super
		this
		
	events:
		"dragover": (e) ->
			e.preventDefault()
			@$el.children().first().addClass "playlistDragOver"
			console.log this

		"dragleave": (e) ->
			@$el.children().first().removeClass "playlistDragOver"

		"drop": (e) ->
			@$el.children().first().removeClass "playlistDragOver"
			folder = e.originalEvent.dataTransfer.getData("folder")
			wavebox.apiClient.addToPlaylist @model.get("id"), [ folder ], =>
				# remove loading spinner and stuff
