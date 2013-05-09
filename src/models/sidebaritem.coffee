#    Filename: sidebaritem.coffee
#      Author: Justin Hill
#        Date: 5/7/2013
#
# Description: Used by sidebaritemview

module.exports = Backbone.Model.extend
	defaults:
		title: ""
		className: ""
		enabled: true

