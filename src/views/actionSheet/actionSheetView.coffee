ActionSheetItems = require "../../collections/actionSheetItems"
ActionSheetItemView = require "./actionSheetItemView"
ActionSheetItem = require "../../models/actionSheetItem"

module.exports = Backbone.View.extend

	tagName: "ul"
	className: "ActionSheet"
	testProp: "something"

	initialize: (options) ->
		@options = options
		@title = options.title
		@collection = new ActionSheetItems
		_.each options.items, (element, index, list) =>
			@collection.push new ActionSheetItem element
	
	events:
		"reset": "render"

	show: ->
		@$el.transit { "margin-bottom": 0, "opacity": "1" }, 300, "ease-in-out"
		###
		$.transit {
			"-webkit-transform": "translateY(#{-@$el.height()})"
			"-moz-transform": "translateY(#{-@$el.height()})"
		}, 300, "ease-in-out"
		###

	hide: ->
		@$el.transit { "margin-bottom": -@$el.height(), "opacity": "0" }, 300, "ease-in-out"
		###
		$.transit {
			"-webkit-transform": "translateY(#{-@$el.height()})"
			"-moz-transform": "translateY(#{-@$el.height()})"
		}, 300, "ease-in-out"
		###

	render: ->
		# render items
		console.log "rendering action sheet"
		temp = document.createElement "a"
		$temp = $(temp)
		@collection.each (element, index, list) =>
			if element.get "enabled"
				view = new ActionSheetItemView model: element
				@listenTo view, "clicked", @hide
				$temp.append view.render().el

		@$el.append $temp.children()
		# start hidden
		@$el.css "margin-bottom", -50 * @collection.length
		this
