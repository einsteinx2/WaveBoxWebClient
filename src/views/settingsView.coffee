PageView = require './pageView'

class SettingsView extends PageView
	tagName: "div"
	template: _.template($("#template-settings").html())
	render: ->
		$page = SettingsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Settings"
			
		$content = $page.find(".page-content")
		$content.append @template()

		@$el.empty().append($page)
		this

module.exports = SettingsView
