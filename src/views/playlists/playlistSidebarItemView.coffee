NavSidebarItemView = require '../navsidebaritemview'

module.exports = class extends NavSidebarItemView
	render: ->
		console.log "playlist render called for " + @model.get "name" 
		@model.set "itemTitle", @model.get "name" 
		super
		this
