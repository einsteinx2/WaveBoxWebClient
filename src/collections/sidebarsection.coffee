#	  Filename: sidebarsection.coffee
#		Author: Justin Hill
#		  Date: 5/9/2013

SidebarItem = require "../models/sidebaritem"

module.exports = Backbone.Collection.extend
	model: SidebarItem
	sync: (method, model, options) ->
		if method is "read"
			console.log "fetching playlists"
		else console.log "Method '#{method}' is undefined"
