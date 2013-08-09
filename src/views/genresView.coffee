PageView = require './pageView'
Genres = require '../collections/genres'
CoverListView = require './coverList/coverListView'

class GenresView extends PageView
	tagName: "div"
	initialize: ->
		@collection = new Genres
		@listenToOnce @collection, "reset", @render
		@collection.fetch reset: true

	render: ->
		result = GenresView.__super__.render
			leftAccessory: "sprite-menu"
			rightAccessory: "sprite-play-queue"
			pageTitle: "Genres"
			search: yes
		$content = result.find(".page-content").addClass("scroll")
		covers = new CoverListView collection: @collection
		$content.append covers.render().el

		@$el.empty().append result.children()
		this



module.exports = GenresView
