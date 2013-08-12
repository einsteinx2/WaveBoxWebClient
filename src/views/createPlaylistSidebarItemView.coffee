#    Filename: createPlaylistSidebarItemView.coffee
#      Author: Justin Hill
#        Date: 7/9/2013

NavSidebarItemView = './navsidebaritemview'

class CreatePlaylistSidebarItemView extends Backbone.View
	tagName: 'li'
	className: 'SidebarIcons'
	template: _.template($("#template-create-playlist-sidebar-item").html())
	events:
		"click": "input"
		"keydown": "keydown"
		"dragover": (e) ->
			return no

	initialize: ->
		@model = new Backbone.Model

	render: ->
		@$el.empty().append @template()
		@delegateEvents()
		this

	keydown: (e) ->
		if e.keyCode is 13
			wavebox.apiClient.createPlaylist $(e.target).val(), (success, error) =>
				if error?
					console.log error
				else
					@model.trigger "changed"

module.exports = CreatePlaylistSidebarItemView
