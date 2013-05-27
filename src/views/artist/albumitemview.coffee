module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'itemWrapper'
	template: _.template($("#template-artist_container").html())

	events:
		"click": ->
			console.log @model
			wavebox.router.navigate "albums/#{@model.get 'albumId'}", trigger: true
	render: ->
		@$el.html @template
			itemTitle: @model.get "albumName"
		this
