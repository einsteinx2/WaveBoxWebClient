PageView = require '../pageView'
SubFolderView = require './subfolderview'
TrackListView = require '../tracklistview'
Folder = require '../../models/folder'

class FolderView extends PageView
	tagName: "div"
	events:
		"click .playAll": "playAll"

	initialize: (options) ->
		@contentLoaded = no
		@folder =
			if options? and options.folderId?
				console.log options.folderId
				new Folder folderId: options.folderId
			else
				new Folder
		@subFolder =
			if options? and options.isSubFolder?
				console.log options.isSubFolder
				options.isSubFolder
			else
				no

		@listenToOnce @folder, "change", =>
			@contentLoaded = yes
			@render()
		@folder.fetch()

	render: ->
		title = if @folder? then (if @folder.get("folderName")? then @folder.get("folderName") else "Folders") else "Folders"
		$page = FolderView.__super__.render
			leftAccessory: if @subFolder then "BackIcon" else "MenuIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: title

		$content = $page.find ".content"
		if @subFolder
			$content.append $("#template-page-collection-actions").html()
		$content.addClass("scroll")
		$folders = $("<div>").addClass "list-cover listView"
		if @contentLoaded
			folders = @folder.get "folders"
			folders.each (folder, index) ->
				view = new SubFolderView model: folder
				$folders.append view.render().el
			if folders.size() > 0
				$content.append $folders

			tracks = @folder.get "tracks"
			console.log @folder
			if tracks.length > 0
				view = new TrackListView collection: tracks, artId: @folder.get("artId")
				$content.append view.render().el
		@$el.empty().append $page
		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @folder, "change", =>
			@folder.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
		@folder.recursive = yes
		@folder.fetch()

module.exports = FolderView
