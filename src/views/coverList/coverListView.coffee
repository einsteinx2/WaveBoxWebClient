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
		filter = @model.get("filter").toLowerCase()

		# Set the infinity options (currently set to defaults of 3 and 350)
		infinity.config.PAGE_TO_SCREEN_RATIO = 3
		infinity.config.SCROLL_THROTTLE = 350

		# Setup inifinity scrolling
		setTimeout =>

			# Add the right side index
			if @collection.positions?
				$sideIndex = $('<div>')
				$sideIndex.addClass "list-index"

				i = 0
				for index in @collection.positions
					$indexItem = $("<p>" + index.Key + "</p>")
					$indexItem.data "position", i
					$indexItem.data "index", index.Value
					$indexItem.data "key", index.Key
					$indexItem.click @clickedIndex
					$sideIndex.append $indexItem
					i++
				@$el.parent().parent().append $sideIndex

			@createInfinityView()

			if wavebox.isMobile() or not @collection.positions?
				# Choose how many covers to load at a time
				@amountToLoad = 50

				# On mobile, just add all the covers directly without a container
				@loadCoversMobile 0, @amountToLoad
			else
				# If desktop, separate the items by letter index
				@sectionKeyIndex = 0
				@sectionCount = 0
				@currentPair = @collection.positions[@sectionKeyIndex]
				@currentPair.scrollTop = 0
				@createContainer(@currentPair.Key)

				@count = 0
				@totalHeight = 0
				@collection.each (item) =>
					if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1

						if item.coverViewFields().title.charAt(0).toUpperCase() != @currentPair.Key
							# We're in a different section now, so size and append the previous container
							rows = Math.ceil(@count / 5)
							rows = 1 if rows is 0
							height = rows * 148 + 35
							@container.height height
							console.log "key: " + @currentPair.Key + "  height: " + height
							@infinityView.append @container
							if not isNaN height
								@totalHeight = @totalHeight + height + 2

							# Grab the next section pair and create a new container
							@count = 0
							@sectionKeyIndex++
							@currentPair = @collection.positions[@sectionKeyIndex]
							@currentPair.scrollTop = @totalHeight
							@createContainer(@currentPair.Key)

						view = new CoverListItemView model: item
						view.render()
						@container.append view.el
						@count++

				rows = Math.ceil(@count / 5)
				rows = 1 if rows is 0
				@container.height (rows * 148 + 35)
				@infinityView.append @container

		, 0

		this

	scrolled: (e) =>
		if @preventScrollEvent? and @preventScrollEvent is true
			###setTimeout =>
				@preventScrollEvent = false
				return
			, 1000###
			@preventScrollEvent = false
			return

		if @initialLoadScrollHeight?
			console.log "scrollTop + innerHeight = " + (@infinityDiv.scrollTop() + @infinityDiv.innerHeight()) + " scrollHeight = " + (@infinityDiv[0].scrollHeight - (@initialLoadScrollHeight / 2))
			
			console.log "scrollTop: " + @infinityDiv.scrollTop()
			if @infinityDiv.scrollTop() <= @initialLoadScrollHeight * .25 and @firstLoadedIndex > 0
				# Load covers before index
				@loadCoversMobile @firstLoadedIndex, @amountToLoad, true, @milliToWait

			else if @infinityDiv.scrollTop() + @infinityDiv.innerHeight() >= @infinityDiv[0].scrollHeight - (@initialLoadScrollHeight * .25)
				# Load more covers
				console.log "half way!"
				@loadCoversMobile @lastLoadedIndex, @amountToLoad, false, @milliToWait

	loadCoversMobile: (index, amount, prepend, delay) =>
		# Set some sane defaults
		if not amount?
			amount = 50

		console.log "loadCoversMobile called, index = " + index + " @collection.length = " + @collection.length
		length = @collection.length
		
		# If there are no more records to process, return
		if (prepend and index < 0) or (not prepend and index >= length)
			return
		
		# Only process #{amount} at a time
		if prepend
			byAmount = -1
			start = index - 1
			end = start - amount
			if end < -1
				end = -1
		else 
			remaining = length - index
			if remaining > amount
				max = amount + index
			else
				max = remaining + index
			byAmount = 1
			start = index
			end = max

		# Create the cover views and add to the infinite view
		console.log "loadCoversMobile processing from " + start + " to " + end
		filter = @model.get("filter").toLowerCase()
		for x in [start...end] by byAmount
			item = @collection.at x
			if item.coverViewFields().title.toLowerCase().indexOf(filter) > -1
				view = new CoverListItemView model: item
				view.render()
				if prepend
					@infinityView.prepend view.$el
				else
					@infinityView.append view.$el

		# If prepending, fix the scroll offset
		scrollTop = @infinityDiv.scrollTop()
		newRows = start - end
		addedHeight = newRows * 60
		@preventScrollEvent = true
		@infinityDiv.scrollTop(scrollTop + addedHeight)

		# Save the last max
		if prepend
			@firstLoadedIndex = end
		else
			@lastLoadedIndex = end
			if not @firstLoadedIndex?
				@firstLoadedIndex = start

				# If this is the first load, scroll down halfway
				if index != 0
					@preventScrollEvent = true
					@infinityDiv.scrollTop(@infinityDiv[0].scrollHeight / 2)

		# If this was the first load, save the scroll height
		if not @initialLoadScrollHeight?
			@initialLoadScrollHeight = @infinityDiv[0].scrollHeight

		# Process more if a delay was set
		if delay? and delay is true
			setTimeout =>
				@loadCoversMobile max, amount, prepend, delay
			, delay

	createInfinityView: =>
		if @infinityView?
			@infinityView.remove()
			@firstLoadedIndex = null
			@lastLoadedIndex = null

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

	createContainer: (letter) ->
		@container = $(document.createElement('div'))
		@container.width 768
		@container.append ("<div style='height: 15px; margin: 10px'>" + letter + "</div>")

	filter: ->
		clearTimeout @filterTimeout
		@filterTimeout = setTimeout @render.bind(this), 100

	clickedIndex: (e) =>
		if wavebox.isMobile()

			wavebox.appController.$el.spin()

			setTimeout =>
				@createInfinityView()
				index = $(e.target).data "index"

				# Allow for us to scroll down halfway in the loaded covers
				coverIndex = index + (@amountToLoad / 2)

				@loadCoversMobile coverIndex, @amountToLoad, false
				wavebox.appController.$el.spin(false)
			, 250

		else
			position = $(e.target).data "position"
			scrollTop = @collection.positions[position].scrollTop
			@infinityDiv.scrollTop(scrollTop)


module.exports = CoverListView
