module.exports = Backbone.View.extend
	tagName: "li"
	className: "albumListingSidebar-item"
	template: _.template($("#template-artistAlbumItem").html())
	initialize: (options) ->
		if options? then @model = options
	render: ->
		console.log @model
		@$el.html @template
			trackNumber: @model.get "trackNumber"
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: @model.formattedDuration()
		this
