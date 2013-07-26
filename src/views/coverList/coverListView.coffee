CoverListItemView = require "./coverListItemView"

class CoverListView extends Backbone.View
	tagName: "div"
	initialize: ->
		@model = new Backbone.Model
		@model.set "filter", ""
		@listenTo @model, "change", @filter

	className: "list-cover"
	render: ->
		if not wavebox.isMobile
			@$el.addClass "scroll"
		$temp = $('<div>')
		filter = @model.get("filter").toLowerCase()

		@collection.each (item) =>
			view = new CoverListItemView item
			$temp.append view.render().el

		@$el.empty().append $temp.children()
		this

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 50

module.exports = CoverListView
