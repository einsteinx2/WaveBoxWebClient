#    Filename: sidebaritemview.coffee
#      Author: Justin Hill
#        Date: 5/8/2013

module.exports = Backbone.View.extend
	tagName: "li"
	className: "SidebarIcons"
	template: _.template($("#template-sideBarItem").html())

	render: ->
		temp = document.createElement "div"
		$temp = $(temp)
				
		$temp.append @template
			itemTitle: @model.get "itemTitle" or ""
			itemClass: @model.get "itemClass" or ""
			href: @model.get "href" or ""

		accessory = @model.get "accessoryClass"
		if accessory?
			ele = document.createElement "a"
			ele.className = "#{accessory} sprite"
			$temp.append ele

		@$el.append temp.innerHTML
		this
