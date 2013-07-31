CoverListItemView = require "./coverListItemView"
InfiniteScroll = require '../infiniteScroll'

class CoverListView extends Backbone.View
	tagName: "div"
	initialize: (options) ->
		@model = new Backbone.Model
		@model.set "filter", ""

		if options?
			@model.set "rows", 

		@listenTo @model, "change", @filter

	className: "list-cover"
	render: ->
		if not wavebox.isMobile
			@$el.addClass "scroll"

		$temp = $('<div>')
		filter = @model.get("filter").toLowerCase()

		@collection.each (item) =>
			view = new CoverListItemView model: item
			$temp.append view.render().el

		@$el.empty().append $temp.children()
		this

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 50

module.exports = CoverListView
