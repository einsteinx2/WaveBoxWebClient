exports.Playlist = Backbone.Model.extend
	initialize: ->
		@tracks = new SongList()