module.exports = Backbone.View.extend
	tagName: "li"
	className: "albumListingSidebar-item"
	template: _.template($("#template-artistAlbumItem").html())
	initialize: (options) ->
		if options? then @model = options

	events:
		"dblclick": ->
			wavebox.audioPlayer.playQueue.add @model
	render: ->
		@$el.html @template
			trackNumber: @model.get "trackNumber"
			songName: @model.get "songName"
			artistName: @model.get "artistName"
			duration: @model.formattedDuration()
		this
