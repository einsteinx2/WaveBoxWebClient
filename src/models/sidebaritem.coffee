#    Filename: sidebaritem.coffee
#      Author: Justin Hill
#        Date: 5/7/2013
#
# Description: Used by sidebaritemview

class SidebarItem extends Backbone.Model
	defaults:
		title: ""
		className: ""
		enabled: true

module.exports = SidebarItem
