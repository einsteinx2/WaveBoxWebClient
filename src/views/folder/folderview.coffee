PageView = require '../pageView'
SubFolderView = require './subfolderview'
TrackListView = require '../tracklistview'
Folder = require '../../models/folder'
CoverListView = require '../coverList/coverListView'
Utils = require '../../utils/utils'

class FolderView extends PageView
	tagName: "div"
	className: "mediaPage"
	events:
		"click .collection-actions-play-all": "playAll"
		"input .page-search-textbox": "search"
	template: _.template($("#template-page-folder").html())

	search: ->
		@covers.model.set "filter", $(event.target).val()

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

		if @contentLoaded

			duration = 0
			tracks.each (track) ->
				duration += track.get("duration")

			duration =
				if duration > 0
					Utils.formattedTimeWithSeconds(duration)
				else
					null


			if @subFolder
				# add the header
				header = @template
					folderName: @folder.get("folderName") or ""
					folderCount: folders.size() or null
					trackCount: tracks.size() or null
					totalDuration: duration or ""

				$content.prepend header

				# add the art to the header
				artId = @folder.get("artId")
				neededWidth = if wavebox.isMobile() then $(document.body).width() else 130
				if artId?
					$content.find(".page-album-cover").css "background-image", "url(#{wavebox.apiClient.getArtUrl(artId, neededWidth)})"
			$content.addClass("scroll")


			if folders.size() > 0
				@covers = new CoverListView collection: folders
				$content.append @covers.render().el

			tracks = @folder.get "tracks"
			console.log @folder
			if tracks.length > 0
				view = new TrackListView collection: tracks
				$content.append view.render().el
		@$el.empty().append $page.children()
		this
	
	playAll: (e) ->
		e.preventDefault()
		@listenToOnce @folder, "change", =>
			@folder.get("tracks").each (track) ->
				wavebox.audioPlayer.playQueue.add track
		@folder.recursive = yes
		@folder.fetch()

module.exports = FolderView
