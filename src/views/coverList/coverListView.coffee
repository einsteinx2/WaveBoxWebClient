CoverListItemView = require "./coverListItemView"
InfiniteScroll = require '../infiniteScroll'

class CoverListView extends Backbone.View
	tagName: "div"
	initialize: (options) ->
		@model = new Backbone.Model
		@model.set "filter", ""
		@listenTo @model, "change", @filter

	className: "list-cover"
	render: ->
		if not wavebox.isMobile()
			@$el.addClass "scroll"

		filter = @model.get("filter").toLowerCase()

		# Only enable infinity on mobile for now
		console.log "is mobile: " + wavebox.isMobile()
		if wavebox.isMobile()
			setTimeout =>

				@infinityView = new infinity.ListView @$el.parent(), {
					useElementScroll: true#,
					lazy: ($element) ->
						# Preload the art for the covers
						for child in $element.children
							$(child).data("backbone-view").preloadArt()
				}

				@collection.each (item) =>
					if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1
						view = new CoverListItemView model: item
						view.render()
						@infinityView.append view.$el
			, 0
		else
			$temp = $('<div>')
			@collection.each (item) =>
				if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1
					view = new CoverListItemView model: item
					$temp.append view.render().el

			@$el.empty().append $temp.children()
		
		this

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 100

module.exports = CoverListView
