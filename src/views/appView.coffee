NavSidebarView = require './navsidebarview'
RightSidebarView = require './rightSidebar/rightsidebarview'
PlayQueueView = require './rightSidebar/playQueue/playQueueView'
SidePanelController = require './sidePanelController'
ViewStack = require '../utils/viewStack'

module.exports = Backbone.View.extend
	el: "body"
	initialize: ->
		# elements must exist at the time of object creation for bindings to work
		@panels = new SidePanelController
			el: @el
			left: NavSidebarView
			right: RightSidebarView
			main: new ViewStack "#main"
		@toggledPanel = null

		@mainView = @panels.main
		#@mainView = new ViewStack "#main"

		$(document).on "unload", (e) ->
			e.preventDefault()

	events:
		"click .sprite-menu": (e) ->
			e.preventDefault()
			@panels.leftToggle()
		"click .sprite-play-queue": (e) ->
			e.preventDefault()
			@panels.rightToggle()
		"click .sprite-back-arrow": (e) ->
			e.preventDefault()
			if @panels.main.canPop()
				@panels.main.pop()
			else
				history.back(1)

	render: ->
		@panels.render().el
	
