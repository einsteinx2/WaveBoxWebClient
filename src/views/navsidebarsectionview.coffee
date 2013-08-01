#	  Filename: sidebarsectionview.coffee
#		Author: Justin Hill
#		  Date: 5/9/2013

SidebarSection = require "../collections/sidebarsection"
SidebarItemView = require "./navsidebaritemview"
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

	renderHeader: ->
		console.log "render header called: #{@title}" 
		if @title?
			header = document.createElement "li"
			header.innerHTML = @title
			header.className = "navigation-section-header"
			@$el.empty().append header

	render: ->
		# render header
		@renderHeader()

		# render items
		temp = document.createElement "a"
		$temp = $(temp)
		@collection.each (element, index, list) ->
			view = new SidebarItemView model: element
			$temp.append view.render().el

		@$el.append $temp.children()
		this

