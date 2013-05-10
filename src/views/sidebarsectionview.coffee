#	  Filename: sidebarsectionview.coffee
#		Author: Justin Hill
#		  Date: 5/9/2013

SidebarSection = require "../collections/sidebarsection"
SidebarItemView = require "./sidebaritemview"
SidebarItem = require "../models/sidebaritem"

module.exports = Backbone.View.extend

	tagName: "ul"
	className: "SidebarMenu"
	defaults:
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
		# render header
		if @title?
			header = document.createElement "span"
			header.innerHTML = @title
			header.className = "titletabs"
			@$el.empty().append header

		# render items
		temp = document.createElement "a"
		$temp = $(temp)
		@collection.each (element, index, list) ->
			view = new SidebarItemView model: element
			rendering = view.render().el
			console.log rendering.innerHTML
			$temp.append rendering.innerHTML

		@$el.append temp.innerHTML
		this

