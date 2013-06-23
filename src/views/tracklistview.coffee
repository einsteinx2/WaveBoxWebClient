TrackListItemView = require "./tracklistitemview"

class TrackList extends Backbone.View
	tagName: "div"
	template: _.template($("#template-trackList").html())

	events:
		"click .playAll": (e) ->
			e.preventDefault()
			console.log this
			@collection.each (track) =>
				wavebox.audioPlayer.playQueue.add track


	render: ->
		$temp = $("<div>")
		$tracks = $("<div>").addClass("trackList scroll")
		$temp.append(@template()).append $tracks

		@collection.each (track) ->
			view = new TrackListItemView model: track
			$tracks.append view.render().el
		@$el.empty().append $temp.children()

		this

module.exports = TrackList
