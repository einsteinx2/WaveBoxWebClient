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
		@animateNext = no
		@$el = $(containerSelector)

	push: (newView, animate, reset = no) ->

		# push a view onto the stack and render it
		return if not newView?

		if not animate?
			animate =
				if wavebox.isMobile()
					yes
				else
					no
		
		bury = @views[@views.length - 1]
		@views.push newView
		
		a = Date.now()
		newView.render()
		console.log "render time: #{Date.now() - a}"

		if bury? and animate
			bury.$el.addClass "viewstack-animate"
			newView.$el.addClass "viewstack-animate viewstack-offscreen-right"

		@$el.append newView.el

		if animate and bury?
			Utils.delay 20, ->
				newView.$el.addClass("viewstack-onscreen")
				bury.$el.addClass "viewstack-offscreen-left"
					
			Utils.delay 600, =>
				newView.$el.removeClass "viewstack-animate viewstack-offscreen-right viewstack-onscreen"
				bury.$el.hide()

		else if bury?
			bury.$el.hide()

		if reset or @resetNext then @reset()

	pop: (animate) ->
		# pop a view off the stack
		top = @views.pop()
		next = @views[@views.length - 1]

		if not animate?
			animate =
				if wavebox.isMobile()
					yes
				else
					no

		if animate
			top.$el.addClass "viewstack-animate"
			next.$el.addClass "viewstack-animate viewstack-offscreen-left"

		next.$el.show()

		if animate
			Utils.delay 20, ->
				top.$el.addClass "viewstack-offscreen-right"
				next.$el.removeClass "viewstack-offscreen-left"

				Utils.delay 600, ->
					top.$el.remove()
		else
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
