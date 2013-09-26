class ServerSearchResultsItemView extends Backbone.View
	tagName: "li"
	className: "server-search-results-item"
	template: _.template($("#template-server-search-result-item").html())

	render: ->
		fields = @model.coverViewFields()
		@$el.empty().append @template
			itemTitle: fields.title

		if fields.artId?
			@$el.find(".server-search-result-item-image").css
				"background-image": wavebox.apiClient.getArtUrl(fields.artId, 50)

		this

module.exports = ServerSearchResultsItemView
