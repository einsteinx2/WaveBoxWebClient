NavSidebarItemView = require '../navsidebaritemview'
ActionSheetView = require '../actionSheet/actionSheetView'

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

		"contextmenu": "contextmenu"

	initialize: ->
		@listenTo wavebox.appController, "sidebarItemSelected", @itemSelected

	itemSelected: (playlistId) ->
		if playlistId is "playlist #{@model.get "id"}" then @$el.addClass("SidebarIconsActive") else @$el.removeClass("SidebarIconsActive")

	render: ->
		@model.set "href", "#playlists/#{@model.get "id"}"
		@model.set
			"itemTitle": @model.get "name"
			"itemClass": "sprite-playlist"
		super
		this

	contextmenu: ->
		console.log "showing action sheet"
		sheet = new ActionSheetView({
			"song": @model
			"items":
				[{
					"itemTitle": "Delete playlist"
					"action": @delete
				}]
			}).render()
		wavebox.appController.mainView.$el.append sheet.el
		sheet.show()
		return no

	delete: =>
		@model.destroy()
		@remove()
