ActionSheetItems = require "../../collections/actionSheetItems"
ActionSheetItemView = require "./actionSheetItemView"
ActionSheetItem = require "../../models/actionSheetItem"

module.exports = Backbone.View.extend

	tagName: "ul"
	className: ->
		if wavebox.isMobile() then "action-sheet" else "context-menu"

	initialize: (options) ->
		@options = options
		@title = options.title
		@collection = new ActionSheetItems
		_.each options.items, (element, index, list) =>
			@collection.push new ActionSheetItem element
	
	events:
		"reset": "render"

	show: ->
		if wavebox.isMobile()
			@$el.transit { y: 0, "opacity": "1" }, 300, "ease-in-out"
		this

	hide: ->
		if wavebox.isMobile()
			@$el.transit { y: 50 * (@collection.length + 1), "opacity": "0" }, 300, "ease-in-out", =>
				@remove()
		else
			@remove()
		this

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

		cancel = new ActionSheetItemView(model: new ActionSheetItem(itemTitle: "Cancel"))
		@listenToOnce cancel, "clicked", @hide
		$temp.append cancel.render().el

		@$el.append $temp.children()

		console.log @options
		if @options.origin? and not wavebox.isMobile()
			@$el.css "-webkit-transform", "translate(#{@options.origin.x}px, #{@options.origin.y}px)"

		if wavebox.isMobile()
			# start hidden
			@$el.css "-webkit-transform", "translate(0px, #{50 * @collection.length}px)"
		this

