#    Filename: sidebaritemview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

module.exports = Backbone.View.extend
	tagName: "li"
	className: "SidebarIcons"
	template: _.template($("#template-sideBarItem").html())

	render: ->
		console.log "rendering an item"
		@$el.empty().append @template
			itemTitle: @model.get("itemTitle")
			itemClass: @model.get("itemClass")
		console.log @$el.html()
		this
