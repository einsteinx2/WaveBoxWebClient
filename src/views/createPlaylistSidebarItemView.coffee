#    Filename: createPlaylistSidebarItemView.coffee
#      Author: Justin Hill
#        Date: 7/9/2013

NavSidebarItemView = './navsidebaritemview'

class CreatePlaylistSidebarItemView extends Backbone.View
	tagName: 'li'
	className: 'SidebarIcons'
	template: _.template($("#template-create-playlist-sidebar-item").html())
	events:
		"input input": "input"
		"dragover": (e) ->
			return no

	render: ->
		@$el.empty().append @template()
		console.log "OMG OMG OMG OMG"
		console.log @template()
		this

	input: (e) ->
		console.log e.keyCode

module.exports = CreatePlaylistSidebarItemView
