exports.AlbumsView = Backbone.View.extend
	tagName: "ul"
	className: "AlbumViewContent scroll"
	el: "#AlbumsView"
	render: ->
		$el.empty()
		_.each @collection, (model, index, collection) ->
			view = new AlbumView model: model
			$el.append view.render()
