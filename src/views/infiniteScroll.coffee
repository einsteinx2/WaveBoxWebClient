class InfiniteScroll extends Backbone.View
	tagName: "div"
	className: "infinite-scroll"
	initialize: (options) ->
		@itemHeight = options.itemHeight
		@items = []
		@visible = []
		@spacer = $("<div class='infinite-scroll-spacer'>")
		@lastSpacerHeight = 0


		document.body.addEventListener "scroll", @scroll, yes
		window.addEventListener "resize", @resize, no

	render: ->
		@$el.empty()
		@visible = []
		@$el.css "height", "#{@items.length * @itemHeight}px"
		numToRender = ((window.innerHeight / @itemHeight) + 2) * @horizontalItemCount()
		console.log "numToRender: #{numToRender}"

		@$el.append @spacer

		for i in [0..numToRender]
			if @items[i]?
				@$el.append @items[i].$el

		@visible = [0..numToRender]
		console.log @visible.length

		this

	resize: =>
		item = @$el.find(".list-cover-item").first()
		console.log "resize! #{@horizontalItemCount()}"
		@scroll()
	scroll: =>
		clearTimeout @scrollDelayTimeout
		scrollDelayCallback = =>
			$scroll = @$el.closest(".scroll")
			top = $scroll.scrollTop()

			# index of the first item to show
			topIndex = Math.floor(top / @itemHeight) * @horizontalItemCount()
			console.log topIndex

			
			# total number that should be rendered
			numToRender = Math.ceil(((window.innerHeight / @itemHeight) + 2) * @horizontalItemCount())

			shouldBeVisible = [topIndex..topIndex + numToRender]
			remove = _.difference(@visible, shouldBeVisible)
			add = _.difference(shouldBeVisible, @visible)
			_.each remove, (index) =>
				console.log "removing #{index}"
				console.log @items[index]
				@items[index].$el.remove()

			console.log add
			console.log remove

			visibleIndices = _.pluck(@visible, 'index')

			# set spacer height
			spacerHeight = Math.floor(topIndex / @horizontalItemCount) * @itemHeight
			@spacer.css "margin-top", "#{spacerHeight}px"

			# indices of items that should be visible
			@visible = shouldBeVisible

			for i in add
				if spacerHeight > @lastSpacerHeight
					console.log "appending #{i}"
					@$el.append @items[i].$el
				else
					console.log "prepending #{i}"
					@$el.prepend @items[i].$el

			@lastSpacerHeight = spacerHeight

			#	for i in shouldBeVisible
			#		console.log i
			#		item = @items[i]
			#		# if it's not visible, add it to the dom
			#		if @visible.indexOf item is null
			#			@visible.push item

		@scrollDelayTimeout = setTimeout scrollDelayCallback, 50

	add: (element) ->
		@items.push
			$el: element
			index: @items.length

	horizontalItemCount: ->
		if wavebox.isMobile()
			1
		else
			width = window.innerWidth
			if width <= 1000 then 5
			else if width <= 1200 then 6
			else 7

module.exports = InfiniteScroll
