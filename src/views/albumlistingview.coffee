module.exports = Backbone.View.extend
	el: "#mainContent"
	template: _.template($("#template-album_listing").html())
	render: ->
		@$el.html @template
