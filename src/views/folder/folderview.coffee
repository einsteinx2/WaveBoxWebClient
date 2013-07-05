SubFolderView = require './subfolderview'
TrackListView = require '../tracklistview'
Folder = require '../../models/folder'

class FolderView extends Backbone.View
	tagName: "div"
	template: _.template($("#template-artistView").html())
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
		@$el.html wavebox.views.pageView
			leftAccessory: if @subFolder then "BackIcon" else "MenuIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: if @folder? then @folder.get("folderName") else ""

		if @subFolder
			@$el.append "<div class='collectionActions'><a class='playAll' href=''>Play all</a></div>"

		$temp = $("<div>").addClass("main-scrollingContent scroll")
		$temp.addClass "noCollectionActions" unless @subFolder
		$folders = $("<div>").addClass "mainContentPadding listView"
		if @contentLoaded
			folders = @folder.get "folders"
			folders.each (folder, index) ->
				view = new SubFolderView model: folder
				$folders.append view.render().el
			if folders.size() > 0
				$temp.append $folders

			tracks = @folder.get "tracks"
			console.log @folder
			if tracks.length > 0
				view = new TrackListView collection: tracks, artId: @folder.get("artId")
				$temp.append view.render().el
		@$el.append $temp
		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @folder, "change", =>
			@folder.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
		@folder.recursive = yes
		@folder.fetch()

module.exports = FolderView
