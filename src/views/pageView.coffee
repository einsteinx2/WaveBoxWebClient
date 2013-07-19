class PageView extends Backbone.View
	tagName: "div"
	template: _.template($("#template-page").html())
	render: (options) ->
		$("<div>").append @template(options)

module.exports = PageView
