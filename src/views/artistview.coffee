module.exports = Backbone.View.extend
	tagName: 'li'
	className: 'AlbumContainer'
	template: _.template($("#template-artist_container").html())
	render: ->
		@$el.html @template
			trackCount: "12"
			albumName: @model.get "albumName"
			artistName: @model.get "artistName"
		this