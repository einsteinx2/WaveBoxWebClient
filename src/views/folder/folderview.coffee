SubFolderView = require './subfolderview'
TrackListView = require '../tracklistview'
Folder = require '../../models/folder'

module.exports = Backbone.View.extend
	tagName: "div"
	template: _.template($("#template-artistView").html())
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

		$temp = $("<div>").addClass("main-scrollingContent artistsMain scroll")
		$temp.addClass "noCollectionActions" unless @subFolder
		$folders = $("<div>")
		$temp.append $folders
		if @contentLoaded
			folders = @folder.get "folders"
			folders.each (folder, index) ->
				view = new SubFolderView model: folder
				$folders.append view.render().el

			tracks = @folder.get "tracks"
			if tracks.length > 0
				view = new TrackListView collection: tracks
				$temp.append view.render().el
		@$el.append $temp
		this
