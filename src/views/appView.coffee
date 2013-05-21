NavSidebarView = require './navsidebarview'
PlaylistSidebarView = require './playlistsidebarview'
FilterSidebarView = require './filtersidebarview'

module.exports = Backbone.View.extend
	el: "body"
	initialize: ->
		@navSidebar = new NavSidebarView().render()
		@playlistSidebar = new PlaylistSidebarView().render()
		@filterSidebar = new FilterSidebarView().render()
		@mainView = null
		@toggledPanel = null

		@on "playlistToggle", @rightPanelToggle
		@on "sidebarToggle", @leftPanelToggle
		@on "filterToggle", @filterPanelToggle
		#@$el.find(".BackIcon", wavebox.appController).click wavebox.appController.leftPanelToggle
		#@$el.find(".PlaylistIcon", wavebox.appController).click wavebox.appController.rightPanelToggle

	events:
		"playlistToggle": -> console.log "playlist toggle"
		"sidebarToggle": -> console.log "sidebar toggle"
			
	render: ->
		if not wavebox.isMobile()
			@rightPanelActive = true
			@leftPanelActive = true
			@filterPanelActive = false
			@mainView.$el.addClass("transitions")
			@mainView.$el.css({left: @navSidebar.$el.width(), width: $(window).width() - @navSidebar.$el.width() - @playlistSidebar.$el.width()})
		else
			@bindTouchEvents()

		$(window).resize =>
			leftPanelWidth = if @leftPanelActive then @navSidebar.$el.width() else 0
			rightPanelWidth = if @rightPanelActive then @playlistSidebar.$el.width() else if @filterPanelActive then @filterSidebar.$el.width() else 0
			@mainView.$el.removeClass("transitions").css({left: leftPanelWidth, width: $(window).width() - leftPanelWidth - rightPanelWidth}).addClass("transitions")

		this

	focusMainPanel: (callback) ->
		@mainView.$el.wbTranslate(0, 200, "ease-out", callback)
		@toggledPanel = null

	switchPanels: (panel) ->
		if panel is "right"
			@playlistSidebar.$el.css "display": "block"
			if wavebox.isMobile() then @navSidebar.$el.css "display": "none"
			@filterSidebar.$el.css "display": "none"
		else if panel is "left"
			@playlistSidebar.$el.css "display": "none"
			if wavebox.isMobile() then @navSidebar.$el.css "display": "block"
			@filterSidebar.$el.css "display": "none"
		else if panel is "filter"
			@playlistSidebar.$el.css "display": "none"
			if wavebox.isMobile() then @navSidebar.$el.css "display": "none"
			@filterSidebar.$el.css "display": "block"
	
	leftPanelToggle: ->
		console.log "toggling the left panel!"
		if wavebox.isMobile()
			if @toggledPanel is null
				@switchPanels "left"
				@mainView.$el.wbTranslate(@navSidebar.$el.width(), 200, "ease-out")
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

	rightPanelToggle: ->
		$this = @mainView.$el
		console.log "clicked rightpaneltoggle.  name: #{this.name}"
		if wavebox.isMobile()
			console.log wavebox.isMobile()
			if @toggledPanel is null or @toggledPanel is "filter"
				if @mainView.$el.css("left") isnt "0px" then @focusMainPanel =>
					@switchPanels "right"
					@mainView.$el.wbTranslate(-@playlistSidebar.$el.width(), 200, "ease-out")
				else
					@switchPanels "right"
					@mainView.$el.wbTranslate(-@playlistSidebar.$el.width(), 200, "ease-out")
				@toggledPanel = "right"
			else
				@focusMainPanel()
		else
			leftoffset = parseInt @mainView.$el.css "left"
			rightwidth = @playlistSidebar.$el.width()

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
		console.log "filterPanelToggle clicked"
		if wavebox.isMobile()
			if @toggledPanel is null or @toggledPanel is "right"
				if @mainView.$el.css("left") isnt "0px" then @focusMainPanel =>
					@switchPanels "filter"
					@mainView.$el.wbTranslate(-$("#filter").width(), 200, "ease-out")
				else
					@switchPanels "filter"
					@mainView.$el.wbTranslate(-$("#filter").width(), 200, "ease-out")
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
						width: @mainView.$el.width() + @playlistSidebar.$el.width()
					setTimeout afterRightClose, 200
					@rightPanelActive = false
				else
					afterRightClose()
	
			else
				@mainView.$el.css
					width: @mainView.$el.width() + filterWidth
				@filterPanelActive = false

	bindTouchEvents: ->
		@$el.bind "touchstart", (event) =>
			$top = $(event.originalEvent.srcElement).closest(".scroll")
			console.log "top: #{$top}"
			$next = $top.children().first()
			bottom = $next.height() - $top.height()
			middle = $next.height() / 2

			console.log "touchStart on body!"
			if $top.scrollTop() is bottom
				$top.scrollTop(bottom - 1)
			else if $top.scrollTop() is 0
				$top.scrollTop(1)

		@$el.bind "touchmove", (event) =>
			$target = $(event.target)
			$parents = $target.parents ".scroll"
			$scrollAnchor = $target.parents ".scrollAnchor"
			if $scrollAnchor.length > 0
				console.log "There's a scroll anchor!"
				$anchor = $scrollAnchor.first()
				if $anchor.height() < $parents.first().height() then event.preventDefault()
			if not ($parents.length > 0 or $target.hasClass ".scroll") then event.preventDefault()

		@mainView.$el.bind "touchstart", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @mainView.$el

			@touchStartX = event.originalEvent.touches[0].pageX - $this.offset().left
			@scrollType = if @touchStartX < 30 or @touchStartX > $this.width() - 30 then "x" else "y"
			@previousX = @touchStartX
			@previousTime = event.timeStamp
			@pixelsPerSecond = 0

		@mainView.$el.bind "touchmove", (event) =>
			return if event.originalEvent.touches.length isnt 1
			$this = @mainView.$el

			if @scrollType is "x"
				event.preventDefault()
				x = event.originalEvent.touches[0].pageX
				@pixelsPerSecond = (x - @previousX) / (event.timeStamp - @previousTime) * 1000

				if @toggledPanel isnt "filter"
					if $this.offset().left < 0
						@switchPanels "right"
					else @switchPanels "left"
				$this.css left: x - @touchStartX

			@previousX = x
			@previousTime = event.timeStamp

		@mainView.$el.bind "touchend", (event) =>
			return if event.originalEvent.touches.length isnt 0 or @scrollType is "y"

			width = @mainView.$el.width()
			left = @mainView.$el.offset().left
			futurePosition = left + @pixelsPerSecond

			left = if @toggledPanel is "filter"
				if futurePosition > 0
					@toggledPanel = null
					0
				else
					-@filterSidebar.$el.width()
			else
				if futurePosition > width / 2 and left > 30
					@toggledPanel = "left"
					console.log "left open"
					@navSidebar.$el.width()
				else if futurePosition < width / -2 and left < -30
					@toggledPanel = "right"
					console.log "right open"
					-@playlistSidebar.$el.width()
				else
					@toggledPanel = null
					console.log "center panel focus"
					0

			@mainView.$el.wbTranslate(left, 200, "ease-out")
			console.log "touchend"
