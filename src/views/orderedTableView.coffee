class OrderedTableView extends Backbone.View
	tagName: "div"
	className: "ordered-table"
	itemTemplate: _.template($("#template-ordered-table-item").html())
	newItemTemplate: _.template($("#template-ordered-table-item-new").html())

	events:
		"click .sprite-plus-tiny": "move"
		"click .sprite-minus-tiny": "move"
		"keydown .ordered-table-item-input": "done"
		"click .sprite-check-mark": "done"

	initialize: (options) ->
		if options.items?
			@items = options.items

	render: ->
		@$el.empty()
		_.each @items, (item, index) =>
			@$el.append @itemTemplate
				title: item
				index: index
		@$el.append @newItemTemplate()
		this

	move: (e) ->
		index = parseInt($(e.target).parent().attr("data-index"))
		destination =
			if e.target.className.indexOf("sprite-minus-tiny") >= 0
				console.log "plus"
				index + 1
			else
				index - 1
		if destination < 0 or destination > @items.length - 1
			return

		@items.splice(destination, 0, @items.splice(index, 1)[0])
		@render()
		console.log

	done: (e) ->
		console.log e.target.nodeName, e.keyCode
		value = ""
		if e.keyCode? and e.keyCode is 13
			value = $(e.target).val()
		else if e.target.nodeName isnt "INPUT"
			value = @$el.find(".ordered-table-item-input").val()

		if value.length > 0
			@add value

	add: (value) ->
		@items.push(value)
		@render()
		@$el.find(".ordered-table-item-input").focus()
		@trigger("change")

module.exports = OrderedTableView
