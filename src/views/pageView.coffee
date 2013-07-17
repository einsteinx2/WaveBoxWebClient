class PageView extends Backbone.View
	tagName: "div"
	template: _.template($("#template-pageView").html())
	render: (options) ->
		$("<div>").append @template(options)

module.exports = PageView
