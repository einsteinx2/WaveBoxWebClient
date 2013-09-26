class window.ServerSearch extends Backbone.Model
	urlRoot: "/api/search"
	defaults:
		results: null

	initialize: ->
		@on("change:query", @search)

	search: ->
		query = @get("query")
		unless query is "" or query is null
			@fetch(data: query: query)
		else
			@set("results", null)

	parse: (response, options) ->
		hash =
			results: response
		return hash

module.exports = ServerSearch
