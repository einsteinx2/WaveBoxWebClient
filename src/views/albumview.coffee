exports.AlbumView = Backbone.View.extend
	tagName: 'li'
	className: 'AlbumContainer'
	template: _.template($("#template-album_container").html())
	render: ->
		$el.append @template
			trackCount: "12"
			albumName: @model.get "albumName"
			artistName: @model.get "artistName"
		this
