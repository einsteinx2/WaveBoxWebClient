ServerSearch = require '../models/serverSearch'
ServerSearchResultsSectionView = require './serverSearchResultsSectionView'
Utils = require '../utils/utils'

class ServerSearchView extends Backbone.View
	template: _.template($("#template-server-search").html())
	events:
		"focus .server-search-input": "focus"
		"blur .server-search-input": "blur"
		"input": "textboxChanged"

	initialize: ->
		@model = new ServerSearch
		@listenTo(@model, "change:results", @renderResults)
		@visible = no
		@inputFocused = no
		@cancelNext = no
		document.addEventListener("keydown", @handleSpecialKeystrokes, yes)

	render: ->
		@$el.append @template()
		@$textbox = @$el.find(".server-search-input")
		@$results = @$el.find(".server-search-results")
		this

	renderResults: (model, value, options) ->
		@$results.empty()
		if value? and @$textbox.val() isnt ""
			for key of value
				if key in ["error", "videos", "artists"]
					continue
				else
					if not @visible
						@trigger("serverSearchResultsToggle")

					view = new ServerSearchResultsSectionView
						type: key
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

	focus: ->
		@inputFocused = yes

	blur: (e) ->
		Utils.delay 200, ->
			@inputFocused = no

	textboxChanged: ->
		@model.set("query", @$textbox.val())

	handleSpecialKeystrokes: (e) =>
		if e.keyCode is 27 and @inputFocused
			@$textbox.val("")
			@textboxChanged()
		return yes

	remove: ->
		document.removeEventListener("keydown", @handleSpecialKeystrokes, yes)
		super()

module.exports = ServerSearchView
