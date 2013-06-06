# viewStack.coffee
#
# Description:
# Provides an implement for a UINavigationStack-style view structure.  Allows for pushing and popping
# onto the stack and animating transitions between views.

Utils = require './utils'

module.exports = class ViewStack

	constructor: (containerSelector) ->
		@views = []
		@resetNext = no
		@$el = $(containerSelector)

	push: (newView, animate = yes, reset = no) ->
		# push a view onto the stack and render it
		return if not newView?
		
		bury = @views[@views.length - 1]
		@views.push newView

		newView.render()

		if animate and bury?
			bury.$el.addClass "viewstack-animate"
			newView.$el.addClass "viewstack-animate viewstack-offscreen-right"

		@$el.append newView.el

		Utils.delay 20, ->
			if animate and bury?
				newView.$el.addClass("viewstack-onscreen")
				bury.$el.addClass "viewstack-offscreen-left"
				
		Utils.delay 620, =>
			if animate and bury?
				newView.$el.removeClass "viewstack-animate viewstack-offscreen-right viewstack-onscreen"
				#bury.$el.hide()

			if reset or @resetNext then @reset()

	pop: (animate = yes) ->
		# pop a view off the stack
		top = @views.pop()
		next = @views[@views.length - 1]

		if animate
			top.$el.addClass "viewstack-animate"
			next.$el.addClass "viewstack-animate viewstack-offscreen-left"

		next.$el.show()

		Utils.delay 20, ->
			top.$el.addClass "viewstack-offscreen-right"
			next.$el.removeClass "viewstack-offscreen-left"

			Utils.delay 600, ->
				top.$el.remove()
	
		h = Backbone.history
		h.navigate h[h.length - 2], no
	
	popToRoot: (animate = yes) ->
		# pop to the root 
	
	reset: ->
		console.log @resetNext
		@resetNext = no
		removeToHere = @views.length - 1
		console.log "resetting! #{removeToHere}"
		for i in [0...removeToHere]
			console.log "Removing #{i}!"
			@views[0].$el.remove()
			@views.splice 0, 1
		
	canPop: ->
		@views.length > 1
