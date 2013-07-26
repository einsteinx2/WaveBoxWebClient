class SidePanelController extends Backbone.View
	el: "body"
	template: _.template($("#template-side-panels").html())
	initialize: (options) ->


		if options?
			@el = options.el

			@$el.prepend @template()

			@left = new options.left
			@right = new options.right
			@main = options.main

		$(window).resize =>
			leftWidth = if @leftActive then @left.$el.width() else 0
			rightWidth = if @rightActive then @right.$el.width() else 0
			@main.$el.removeClass("transitions")
				.css({ left: leftWidth, width: $(window).width() - leftWidth - rightWidth})
				.addClass("transitions")

		
	render: ->
		
		if not wavebox.isMobile()
			@rightActive = true
			@leftActive = true
			@main.$el.addClass("transitions")
			@main.$el.css
				left: @left.$el.width() 
				width: $(window).width() - @left.$el.width() - @right.$el.width()
		else
			@bindTouchEvents()

		console.log "rendering left"

		@left.render()
		console.log "rendering right"
		@right.render()

		this

	focusMain: (callback) ->
		@main.$el.transition({x: 0}, 200, "ease-out", callback)
		@toggledPanel = null
		
	switch: (panel) ->
		if panel is "right"
			if wavebox.isMobile() 
				@left.$el.css "z-index": -10
				@right.$el.css "z-index": 10
			else
				@left.$el.css "display": "none"
				@right.$el.css "display": "block"
		else if panel is "left"
			if wavebox.isMobile() 
				@right.$el.css "z-index": -10
				@left.$el.css "z-index": 10
			else
				@left.$el.css "display": "block"
				@right.$el.css "display": "none"
	
	leftToggle: ->
		if wavebox.isMobile()
			if @toggledPanel is null
				@switch "left"
				@main.$el.transition({x: @left.$el.width()}, 200, "ease-out")
				@toggledPanel = "left"
			else
				@focusMain()
		else
			leftwidth = @left.$el.width()
			if not @leftActive
				console.log "do it son #{@constructor.name}"
				@main.$el.css
					left: leftwidth
					width: @main.$el.width() - leftwidth
				@leftActive = true
			else
				@main.$el.css
					left: 0
					width: @main.$el.width() + leftwidth
				@leftActive = false

	rightToggle: (duration = 200)->
		$this = @main.$el
		if wavebox.isMobile()
			if @toggledPanel is null
				@switch "right"
				@main.$el.transition({x: -@right.$el.width()}, duration, "ease-out")
				@toggledPanel = "right"
			else
				@focusMain()
		else
			if not @rightActive
				@switch "right"
				@main.$el.css
					width: @main.$el.width() - @right.$el.width()
				@rightActive = true

			else
				@main.$el.css
					width: @main.$el.width() + @right.$el.width()
				@rightActive = false

	bindTouchEvents: ->
		# FastClick!
		FastClick.attach(document.body)

		###
		Touch handling for vertical scrolling of center panel
		###
		
		@$el.bind "touchstart", (event) =>
			$target = $(event.target)
			$top = $target.parents(".scroll").first()

			bottom = if $top[0]? then $top[0].scrollHeight - $top.outerHeight() else -$top.outerHeight()

			if $top.scrollTop() < $top.height() / 2
				$top.scrollTop(1)
			else
				$top.scrollTop(bottom - 1)
			
		@$el.bind "touchmove", (event) =>
			$target = $(event.target)
			$parents = $target.parents ".scroll"
			$scrollAnchor = $target.parents ".scrollAnchor"
			if $scrollAnchor.length > 0
				$anchor = $scrollAnchor.first()
				$scroll = $parents.first()
				if $scroll.height() < $anchor.height()
					console.log "anchor height smaller than parent"
					event.preventDefault()
			if not ($parents.length > 0 or $target.hasClass ".scroll")
				console.log "no parent or no scroll"
				event.preventDefault()

		###
		Touch handling for horizontal scrolling of panels
		###

		@main.$el.bind "touchstart", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @main.$el

			@touchStartX = event.originalEvent.touches[0].pageX - $this.offset().left
			@scrollType = if @touchStartX < 10 or @touchStartX > $this.width() - 10 then "x" else "y"

			# If we're on mobile, and either panel is open, only allow panel dragging
			@scrollType = if wavebox.isMobile() and @toggledPanel isnt null then "x" else @scrollType
			@previousX = @touchStartX
			@previousTime = event.timeStamp
			@pixelsPerSecond = 0

		@main.$el.bind "touchmove", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @main.$el

			if @scrollType is "x"
				event.preventDefault()
				x = event.originalEvent.touches[0].pageX

				# Don't allow scrolling past the left edge when dragging the left side of the screen
				if @touchStartX < 100 and x < @previousX and $this.offset().left <= 0
					$this.offset().left = 0
					return

				# Don't allow scrolling past the right edge when dragging the right side of the screen
				if @touchStartX > $this.width() - 100 and x > @previousX and $this.offset().left >= 0
					$this.offset().left = 0
					return

				# Calculate the dragging speed
				@pixelsPerSecond = (x - @previousX) / (event.timeStamp - @previousTime) * 1000

				if $this.offset().left < 0
					@switch "right"
				else @switch "left"

				$this.css "-webkit-transform": "translate3d(#{x - @touchStartX}px, 0, 0)"

			@previousX = x
			@previousTime = event.timeStamp

		@main.$el.bind "touchend", (event) =>
			return if event.originalEvent.touches.length isnt 0 or @scrollType is "y"

			width = @main.$el.width()
			left = @main.$el.offset().left
			futurePosition = left + @pixelsPerSecond

			left = 
				if futurePosition > @left.$el.width() * .75 and left > 30
					@toggledPanel = "left"
					@left.$el.width()
				else if futurePosition + width < width - (@right.$el.width() * .75) and left < -30
					@toggledPanel = "right"
					-@right.$el.width()
				else
					@toggledPanel = null
					0

			@main.$el.transition({x: left}, 200, "ease-out")

module.exports = SidePanelController 
