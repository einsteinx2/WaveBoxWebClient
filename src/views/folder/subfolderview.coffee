module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'itemWrapper'
	template: _.template($("#template-artist_container").html())

	events:
		"click": ->
			wavebox.router.navigate "folders/#{@model.get 'folderId'}", trigger: true
	render: ->
		@$el.html @template
			itemTitle: @model.get "folderName"

		$artImg = @$el.find("img").first()
		art = new Image()
		art.onload = =>
			@$el.children(":first-child").css "background-image", "url(#{url})"

		url = wavebox.apiClient.getArtUrl @model.get("artId"), 200
		art.src = url

		this
