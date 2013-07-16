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

	render: ->
		@panels.render().el
	
