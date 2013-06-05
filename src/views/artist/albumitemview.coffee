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

		$artImg = @$el.find("img").first()
		art = new Image()
		art.onload = =>
			@$el.children(":first-child").css "background-image", "url(#{url})"

		url = wavebox.apiClient.getArtUrl @model.get("artId"), 200
		art.src = url
		console.log url

		this
