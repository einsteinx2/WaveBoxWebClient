#    Filename: sidebaritemview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

module.exports = Backbone.View.extend
	tagName: "a"
	template: _.template($("#template-sideBarItem").html())

	events:
		"click": (e) ->
			wavebox.appController.mainView.resetNext = yes

	render: ->
		temp = document.createElement "div"
		$temp = $(temp)
				
		$temp.append @template
			itemTitle: @model.get "itemTitle" or ""
			itemClass: @model.get "itemClass" or ""
		@$el.attr "href", @model.get("href") or ""

		@$el.append $temp.children()
		this
