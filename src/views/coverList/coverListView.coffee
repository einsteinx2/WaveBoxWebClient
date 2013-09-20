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

		# Setup inifinity scrolling
		setTimeout =>
			@infinityView = new infinity.ListView @$el.parent(), {
				useElementScroll: true#,
				lazy: ($element) ->
					# Preload the art for the covers
					children = if wavebox.isMobile() then $element.children else $element.children[0].children
					for child in children
						backboneView = $(child).data("backbone-view")
						if backboneView?
							backboneView.preloadArt()
			}

			if wavebox.isMobile()
				# If mobile, just add all the covers directly
				@collection.each (item) =>
					if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1
						view = new CoverListItemView model: item
						view.render()
						@infinityView.append view.$el
			else
				# If desktop, separate the items by letter index
				@sectionKeyIndex = 0
				@sectionCount = 0
				@currentPair = @collection.positions[@sectionKeyIndex]
				@createContainer(@currentPair.Key)

				@collection.each (item) =>
					if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1

						if item.coverViewFields().title.charAt(0).toUpperCase() != @currentPair.Key
							# We're in a different section now, so size and append the previous container
							rows = Math.ceil(@count / 5)
							rows = 1 if rows is 0
							@container.height (rows * 148 + 35)
							console.log("key: " + @currentPair.Key + " count: " + @count + " rows: " + rows + " height: " + @container.height())
							@infinityView.append @container

							# Grab the next section pair and create a new container
							@count = 0
							@sectionKeyIndex++
							@currentPair = @collection.positions[@sectionKeyIndex]
							@createContainer(@currentPair.Key)

						view = new CoverListItemView model: item
						view.render()
						@container.append view.el
						@count++

				rows = Math.ceil(@count / 5)
				rows = 1 if rows is 0
				@container.height (rows * 148 + 35)
				console.log("key: " + @currentPair.Key + " count: " + @count + " rows: " + rows + " height: " + @container.height())
				@infinityView.append @container


		, 0

		this

	createContainer: (letter) ->
		@container = $(document.createElement('div'))
		@container.width 768
		@container.append ("<div style='height: 15px; margin: 10px'>" + letter + "</div>")

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 100

module.exports = CoverListView
