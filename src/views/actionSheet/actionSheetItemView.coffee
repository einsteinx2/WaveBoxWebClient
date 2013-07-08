module.exports = Backbone.View.extend
	tagName: "a"
	template: _.template($("#template-actionSheetItem").html())

	events:
		"click": (e) -> 
			e.preventDefault()
			@trigger "clicked"
			console.log "clicked triggered"
			action = @model.get "action"
			if action? then action()

	render: ->
		temp = document.createElement "div"
		$temp = $(temp)
				
		$temp.append @template
			itemTitle: @model.get "itemTitle" or ""
			itemClass: @model.get "itemClass" or ""
		@$el.attr "href", @model.get("href") or ""

		@$el.append $temp.children()
		this
