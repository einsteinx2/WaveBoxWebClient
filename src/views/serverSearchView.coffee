ServerSearch = require '../models/serverSearch'
ServerSearchResultsSectionView = require './serverSearchResultsSectionView'

class ServerSearchView extends Backbone.View
	template: _.template($("#template-server-search").html())
	events:
		"input": "textboxChanged"

	initialize: ->
		@model = new ServerSearch
		@listenTo(@model, "change:results", @renderResults)
		@visible = no

	render: ->
		@$el.append @template()
		@$textbox = @$el.find(".server-search-input")
		@$results = @$el.find(".server-search-results")
		this

	renderResults: (model, value, options) ->
		@$results.empty()
		if value?
			for key of value
				if key is "error" or key is "videos"
					continue
				else
					if not @visible
						@trigger("serverSearchResultsToggle")
					view = new ServerSearchResultsSectionView
						title: key
						collection: value[key]
					@$results.append(view.render().el)
		else if @visible
			@trigger("serverSearchResultsToggle")

	hide: ->
		@$results.css("opacity", "0")
		@visible = no

	show: ->
		@$results.css("opacity", "1")
		@visible = yes

	textboxChanged: ->
		@model.set("query", @$textbox.val())
		console.log @$textbox.val()

module.exports = ServerSearchView
