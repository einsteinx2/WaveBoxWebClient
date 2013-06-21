Folder = require '../models/folder'

class FolderList extends Backbone.Collection
	model: Folder
	initialize: ->
		console.log "hello world"
		console.log @models

module.exports = FolderList
