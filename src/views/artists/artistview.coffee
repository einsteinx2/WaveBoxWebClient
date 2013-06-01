module.exports = Backbone.View.extend
	tagName: 'div'
	className: 'itemWrapper'
	template: _.template($("#template-artist_container").html())

	events:
		"click": ->
			console.log @model
			wavebox.router.navigate "artists/#{@model.get 'artistId'}", trigger: true
	render: ->
		random = Math.floor(Math.random() * 100)
		if random is 12 then random = 13
		@$el.html @template
			itemTitle: @model.get "artistName"
			#color = ''+Math.floor(Math.random()*16777215).toString(16)
			#	@$el.attr 'data-img-url': "http://placehold.it/200/#{color}/ffffff"
		@$el.find('img').first().attr("src", "http://placekitten.com/#{random}/#{random}")
		this
