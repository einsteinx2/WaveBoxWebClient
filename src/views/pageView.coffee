class PageView extends Backbone.View
	tagName: "div"
	template: _.template($("#template-page").html())
	search: _.template($("#template-page-search").html())
	render: (options) ->
		$page = $("<div>")
		$page.append @template(options)
		if options.search is yes
			$page.find(".page-content").addClass("page-content-search").before @search()

		return $page

module.exports = PageView
