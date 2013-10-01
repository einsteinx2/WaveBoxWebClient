PageView = require './pageView'
OrderedTableView = require './orderedTableView'
Settings = require '../models/settings'

class SettingsView extends PageView
	tagName: "div"
	template: _.template($("#template-settings").html())
	initialize: ->
		@model = new Settings
		@listenToOnce @model, "change", @render
		@model.fetch()
	render: ->
		table = new OrderedTableView items: @model.get("folderArtNames")
		$page = SettingsView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Settings"

		$content = $page.find(".page-content")
		$content.append @template()
		$content.append table.render().el

		@$el.empty().append($page)
		this

module.exports = SettingsView
