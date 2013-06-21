NavSidebarItemView = require '../navsidebaritemview'

module.exports = class extends NavSidebarItemView
	render: ->
		@model.set "href", "#playlists/#{@model.get "id"}"
		@model.set "itemTitle", @model.get "name" 
		super
		this
