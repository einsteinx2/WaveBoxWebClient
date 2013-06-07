NavSidebarView = require './navsidebarview'
MiniPlayerSidebarView = require './rightSidebar/miniPlayer/miniPlayerView'
PlayQueueView = require './rightSidebar/playQueue/playQueueView'
FilterSidebarView = require './filtersidebarview'
ViewStack = require '../utils/viewStack'

module.exports = Backbone.View.extend
	el: "body"
	initialize: ->
		@navSidebar = new NavSidebarView
		@miniPlayerSidebarView = new MiniPlayerSidebarView
		@playQueueSidebarView = new PlayQueueView model: wavebox.audioPlayer.playQueue
		@filterSidebar = new FilterSidebarView
		@mainView = new ViewStack "#main"
		@toggledPanel = null

		$(document).on "unload", (e) ->
			e.preventDefault()

	events:
		"click .MenuIcon": (e) ->
			e.preventDefault()
			@leftPanelToggle()
		"click .BackIcon": (e) ->
			e.preventDefault()
			if wavebox.appController.mainView.canPop()
				wavebox.appController.mainView.pop()
			else
				history.back(1)
		"click .PlaylistIcon": (e) ->
			e.preventDefault()
			@rightPanelToggle()
		"click .FilterIcon": (e) ->
			e.preventDefault()
			@filterPanelToggle()

	render: ->
		@navSidebar.render()
		@miniPlayerSidebarView.render()
		@playQueueSidebarView.render()
		@filterSidebar.render()

		if not wavebox.isMobile()
			@rightPanelActive = true
			@leftPanelActive = true
			@filterPanelActive = false
			@mainView.$el.addClass("transitions")
			@mainView.$el.css({left: @navSidebar.$el.width(), width: $(window).width() - @navSidebar.$el.width() - @playQueueSidebarView.$el.width()})
		else
			@bindTouchEvents()

		$(window).resize =>
			leftPanelWidth = if @leftPanelActive then @navSidebar.$el.width() else 0
			rightPanelWidth = if @rightPanelActive then @playQueueSidebarView.$el.width() else if @filterPanelActive then @filterSidebar.$el.width() else 0
			@mainView.$el.removeClass("transitions").css({left: leftPanelWidth, width: $(window).width() - leftPanelWidth - rightPanelWidth}).addClass("transitions")

		this

	focusMainPanel: (callback) ->
		@mainView.$el.transition({x: 0}, 200, "ease-out", callback)
		@toggledPanel = null
		
	switchPanels: (panel) ->
		if panel is "right"
			$("#right").css "display": "block"
			if wavebox.isMobile() then $("#left").css "display": "none"
			@filterSidebar.$el.css "display": "none"
		else if panel is "left"
			$("#right").css "display": "none"
			if wavebox.isMobile() then $("#left").css "display": "block"
			@filterSidebar.$el.css "display": "none"
		else if panel is "filter"
			$("#right").css "display": "none"
			if wavebox.isMobile() then $("#left").$el.css "display": "none"
			@filterSidebar.$el.css "display": "block"
	
	leftPanelToggle: ->
		if wavebox.isMobile()
			if @toggledPanel is null
				@switchPanels "left"
				@mainView.$el.transition({x: @navSidebar.$el.width()}, 200, "ease-out")
				@toggledPanel = "left"
			else
				@focusMainPanel()
		else
			leftwidth = @navSidebar.$el.width()
			if not @leftPanelActive
				@mainView.$el.css
					left: leftwidth
					width: @mainView.$el.width() - leftwidth
				@leftPanelActive = true
			else
				@mainView.$el.css
					left: 0
					width: @mainView.$el.width() + leftwidth
				@leftPanelActive = false

	rightPanelToggle: (duration = 200)->
		$this = @mainView.$el
		if wavebox.isMobile()
			if @toggledPanel is null or @toggledPanel is "filter"
				if @mainView.$el.css("left") isnt "0px" then @focusMainPanel =>
					@switchPanels "right"
					@mainView.$el.transition({x: -@playQueueSidebarView.$el.width()}, duration, "ease-out")
				else
					@switchPanels "right"
					@mainView.$el.transition({x: -@playQueueSidebarView.$el.width()}, duration, "ease-out")
				@toggledPanel = "right"
			else
				@focusMainPanel()
		else
			leftoffset = parseInt @mainView.$el.css "left"
			rightwidth = @playQueueSidebarView.$el.width()

			if not @rightPanelActive
				afterfilterclose = =>
					@switchPanels "right"
					@mainView.$el.css
						width: @mainView.$el.width() - rightwidth
					@rightPanelActive = true

				if @filterPanelActive
					@mainView.$el.css
						width: @mainView.$el.width() + @filterSidebar.$el.width()
					settimeout afterfilterclose, 200
					@filterPanelActive = false
				else
					afterfilterclose()

			else
				@mainView.$el.css
					width: @mainView.$el.width() + rightwidth
				@rightPanelActive = false


	filterPanelToggle: ->
		if wavebox.isMobile()
			if @toggledPanel is null or @toggledPanel is "right"
				if @mainView.$el.css("left") isnt "0px" then @focusMainPanel =>
					@switchPanels "filter"
					@mainView.$el.transition({x: -$("#filter").width()}, 200, "ease-out")
				else
					@switchPanels "filter"
					@mainView.$el.transition({x: -$("#filter").width()}, 200, "ease-out")
				@toggledPanel = "filter"
			else
				@focusMainPanel()
		else
			filterWidth = @filterSidebar.$el.width()
	
			if not @filterPanelActive
				afterRightClose = () ->
					@switchPanels "filter"
					@mainView.$el.css
						width: @mainView.$el.width() - filterWidth
					@filterPanelActive = true
	
				if @rightPanelActive
					@mainView.$el.css
						width: @mainView.$el.width() + @playQueueSidebarView.$el.width()
					setTimeout afterRightClose, 200
					@rightPanelActive = false
				else
					afterRightClose()
	
			else
				@mainView.$el.css
					width: @mainView.$el.width() + filterWidth
				@filterPanelActive = false

	bindTouchEvents: ->

		###
		Touch handling for vertical scrolling of center panel
		###

		@$el.bind "touchstart", (event) =>
			$top = $(event.originalEvent.srcElement).closest(".scroll")
			bottom = if $top[0]? then $top[0].scrollHeight - $top.outerHeight() else -$top.outerHeight()

			if $top.scrollTop() is bottom
				$top.scrollTop(bottom - 1)
			else if $top.scrollTop() is 0
				$top.scrollTop(1)

		@$el.bind "touchmove", (event) =>
			$target = $(event.target)
			$parents = $target.parents ".scroll"
			$scrollAnchor = $target.parents ".scrollAnchor"
			if $scrollAnchor.length > 0
				$anchor = $scrollAnchor.first()
				if $anchor.height() < $parents.first().height() then event.preventDefault()
			if not ($parents.length > 0 or $target.hasClass ".scroll") then event.preventDefault()

		###
		Touch handling for horizontal scrolling of panels
		###

		@mainView.$el.bind "touchstart", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @mainView.$el

			@touchStartX = event.originalEvent.touches[0].pageX - $this.offset().left
			@scrollType = if @touchStartX < 100 or @touchStartX > $this.width() - 100 then "x" else "y"
			# If we're on mobile, and either panel is open, only allow panel dragging
			@scrollType = if wavebox.isMobile() and @toggledPanel isnt null then "x" else @scrollType
			@previousX = @touchStartX
			@previousTime = event.timeStamp
			@pixelsPerSecond = 0

		@mainView.$el.bind "touchmove", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @mainView.$el

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

				if @toggledPanel isnt "filter"
					if $this.offset().left < 0
						@switchPanels "right"
					else @switchPanels "left"
				$this.css "-webkit-transform": "translate3d(#{x - @touchStartX}px, 0, 0)"

			@previousX = x
			@previousTime = event.timeStamp

		@mainView.$el.bind "touchend", (event) =>
			return if event.originalEvent.touches.length isnt 0 or @scrollType is "y"

			width = @mainView.$el.width()
			left = @mainView.$el.offset().left
			futurePosition = left + @pixelsPerSecond

			left = 
				if @toggledPanel is "filter"
					if futurePosition > 0
						@toggledPanel = null
						0
					else
						-@filterSidebar.$el.width()
				else
					if futurePosition > @navSidebar.$el.width() * .75 and left > 30
						@toggledPanel = "left"
						@navSidebar.$el.width()
					else if futurePosition + width < width - (@playQueueSidebarView.$el.width() * .75) and left < -30
						@toggledPanel = "right"
						-@playQueueSidebarView.$el.width()
					else
						@toggledPanel = null
						0

			@mainView.$el.transition({x: left}, 200, "ease-out")
