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

		# Set the infinity options (currently set to defaults of 3 and 350)
		infinity.config.PAGE_TO_SCREEN_RATIO = 3
		infinity.config.SCROLL_THROTTLE = 350

		# Choose how many covers to load at a time
		@amountToLoad = 25

		# Setup inifinity scrolling
		setTimeout =>

			# Add the right side index
			if @collection.positions?
				$sideIndex = $('<div>')
				$sideIndex.addClass "list-index"
				for index in @collection.positions
					$indexItem = $("<p>" + index.Key + "</p>")
					$indexItem.data "index", index.Value
					$sideIndex.append $indexItem
				@$el.parent().append $sideIndex

			@infinityDiv = @$el.parent()
			@infinityDiv.scroll @scrolled

			@infinityView = new infinity.ListView @infinityDiv, {
				useElementScroll: true#,
				lazy: ($element) ->
					# Preload the art for the covers
					children =
						if wavebox.isMobile() or (@collection? and not @collection.positions)
							$element.children
						else $element.children[0].children

					for child in children
						backboneView = $(child).data("backbone-view")
						if backboneView?
							backboneView.preloadArt()
			}

			if wavebox.isMobile() or not @collection.positions?
				# If mobile, just add all the covers directly
				@loadCoversMobile 0, @amountToLoad
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

	scrolled: (e) =>
		if @initialLoadScrollHeight?
			console.log "scrollTop + innerHeight = " + (@infinityDiv.scrollTop() + @infinityDiv.innerHeight()) + " scrollHeight = " + (@infinityDiv[0].scrollHeight - (@initialLoadScrollHeight / 2))
			if @infinityDiv.scrollTop() + @infinityDiv.innerHeight() >= @infinityDiv[0].scrollHeight - (@initialLoadScrollHeight / 2)
				# Load more covers
				console.log "half way!"
				@loadCoversMobile @lastLoadedIndex, @amountToLoad, @milliToWait

	loadCoversMobile: (index, amount, delay) =>
		# Set some sane defaults
		if not amount?
			amount = 50

		console.log "loadCoversMobile called, index = " + index + " @collection.length = " + @collection.length
		length = @collection.length
		
		# If there are no more records to process, return
		if index >= length
			return
		
		# Only process #{amount} at a time
		remaining = length - index
		if remaining > amount
			max = amount + index
		else
			max = remaining + index

		# Create the cover views and add to the infinite view
		console.log "loadCoversMobile processing from " + index + " to " + max
		filter = @model.get("filter").toLowerCase()
		for x in [index...max] by 1
			item = @collection.at x
			if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1
				view = new CoverListItemView model: item
				view.render()
				@infinityView.append view.$el

		# Save the last max
		@lastLoadedIndex = max

		# If this was the first load, save the scroll height
		if index is 0
			@initialLoadScrollHeight = @infinityDiv[0].scrollHeight

		# Process more if a delay was set
		if delay?
			setTimeout =>
				@loadCoversMobile max, amount, delay
			, delay

	createContainer: (letter) ->
		@container = $(document.createElement('div'))
		@container.width 768
		@container.append ("<div style='height: 15px; margin: 10px'>" + letter + "</div>")

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 100

module.exports = CoverListView
