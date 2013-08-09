Folder = require '../models/folder'

class FolderList extends Backbone.Collection
	model: Folder
	initialize: ->
		console.log "hello world"
		console.log @models

window.FolderList = FolderList

module.exports = FolderList
