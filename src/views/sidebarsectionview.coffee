#	  Filename: sidebarsectionview.coffee
#		Author: Justin Hill
#		  Date: 5/9/2013

SidebarSection = require "../collections/sidebarsection"
SidebarItemView = require "./sidebaritemview"
SidebarItem = require "../models/sidebaritem"

module.exports = Backbone.View.extend

	tagName: "ul"
	defaults:
		title: "Sidebar section"
		collection: new SidebarSection

	initialize: (options) ->
		@options = options
		@title = options.title
		models = []
		_.each options.items, (element, index, list) =>
			models.push new SidebarItem element

		@collection = new SidebarSection models
	
	events:
		"reset": "render"

	render: ->
		console.log "rendering a section"
		temp = $("<a>")
		@collection.each (element, index, list) ->
			view = new SidebarItemView model: element
			temp.append view.render().el
		@$el.empty().append temp.html()
		this

