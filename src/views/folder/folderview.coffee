SubFolderView = require './subfolderview'
Folder = require '../../models/folder'

module.exports = Backbone.View.extend
	tagName: "div"
	template: _.template($("#template-artistView").html())
	initialize: (folderId, isSubFolder) ->
		@contentLoaded = no
		@folder =
			if folderId?
				new Folder folderId
			else
				new Folder

		@listenToOnce @folder, "change", =>
			@contentLoaded = yes
			@render()
		@folder.fetch()
		@subFolder =
			if subFolder?
				subFolder
			else
				no

	render: ->
		@$el.html wavebox.views.pageView
			leftAccessory: if @subFolder then "BackIcon" else "MenuIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: if @folder? then @folder.get("folderName") else ""

		$temp = $("<div>").addClass("main-scrollingContent artistsMain scroll")
		if @contentLoaded
			folders = @folder.get "folders"
			folders.each (folder, index) ->
				view = new SubFolderView model: folder
				$temp.append view.render().el

		@$el.append $temp
		this
