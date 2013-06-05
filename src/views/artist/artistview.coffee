AlbumItemView = require './albumitemview'
Artist = require '../../models/artist'

module.exports = Backbone.View.extend
	el: "#main"
	template: _.template($("#template-artistView").html())
	initialize: (artistId) ->
		@contentLoaded = no
		if artistId?
			@artist = new Artist artistId
			@listenToOnce @artist, "change", =>
				@contentLoaded = yes
				console.log "changed!"
				console.log @artist
				@render()
			@artist.fetch()
	
	render: ->
		@$el.html wavebox.views.pageView
			leftAccessory: "BackIcon"
			rightAccessory: "PlaylistIcon"
			artUrl: ""
			pageTitle: @artist.get("artistName") or ""

		$temp = $("<div>").addClass("main-scrollingContent artistMain scroll")
		console.log @contentLoaded
		if @contentLoaded
			albums = @artist.get "albums"
			albums.each (album, index) ->
				view = new AlbumItemView model: album
				$temp.append view.render().el

		@$el.append $temp
		this
