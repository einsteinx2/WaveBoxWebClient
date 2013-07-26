PageView = require '../pageView'
SubFolderView = require './subfolderview'
TrackListView = require '../tracklistview'
Folder = require '../../models/folder'
CoverListView = require '../coverList/coverListView'

class FolderView extends PageView
	tagName: "div"
	events:
		"click .collection-actions-play-all": "playAll"

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
		folders = @folder.get("folders") or {}
		tracks = @folder.get("tracks") or {}

		$page = FolderView.__super__.render
			leftAccessory: if @subFolder then "sprite-back-arrow" else "sprite-menu"
			rightAccessory: "sprite-play-queue"
			artUrl: ""
			pageTitle: title
			search: folders.length > 0

		$content = $page.find ".page-content"
		if @subFolder
			$content.append $("#template-page-collection-actions").html()
		$content.addClass("scroll")
		if @contentLoaded

			if folders.size() > 0
				view = new CoverListView collection: folders
				$content.append view.render().el

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
