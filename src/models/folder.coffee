FolderList = require '../collections/folderlist'
TrackList = require '../collections/tracklist'

class Folder extends Backbone.Model
	defaults:
		folderId: null
		folderName: null
		parentFolderId: null
		mediaFolderId: null
		folderPath: null
		artId: null
		folders: null
		tracks: null

	initialize: (options) ->
		if options?
			@folderId = options.folderId or null
			@recursive = options.recursive or no
	
	pageUrl: ->
		"/folders/#{@get("folderId")}"

	coverViewFields: ->
		title: @get "folderName"
		artId: @get "artId"

	sync: (method, model, options) ->
		if method is "read"
			wavebox.apiClient.getFolder @folderId, @recursive, (success, data) =>
				if success
					# HACK: This seems really hacky, but basically, errors are thrown
					# whenever you try to provide the raw folder objects to the collection
					# constructor. This probably has something to do with the fact that there 
					# is a circular require between Folder and FolderList. Something
					# to troubleshoot someday when you're bored.
					folderModels = _.map data.folders, (item) ->
						new Folder item

					theFolder = data.containingFolder or {}
					theFolder.folders = new Backbone.Collection(folderModels)
					theFolder.folders.positions = data.sectionPositions
					theFolder.tracks = new TrackList data.songs, comparator: "trackNumber"
					@set theFolder
				else
					options.error data
							
module.exports = Folder
