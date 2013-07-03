NavSidebarItemView = require '../navsidebaritemview'

module.exports = class extends NavSidebarItemView
	events:
		"dragover": (e) ->
			e.preventDefault()
			@$el.children().first().addClass "playlistDragOver"

		"dragleave": (e) ->
			@$el.children().first().removeClass "playlistDragOver"

		"drop": (e) ->
			@$el.children().first().removeClass "playlistDragOver"
			item = wavebox.dragDrop.dropObject
			itemId = item.get("itemId") or item.get("folderId") or item.get("artistId") or item.get("albumId")
			wavebox.apiClient.addToPlaylist @model.get("id"), [ itemId ], =>
				# remove loading spinner and stuff
			wavebox.dragDrop.mediaDragEnd()
	render: ->
		@model.set "href", "#playlists/#{@model.get "id"}"
		@model.set
			"itemTitle": @model.get "name"
			"itemClass": "Playlists sprite"
		super
		this
