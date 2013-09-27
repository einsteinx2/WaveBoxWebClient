class ServerSearchResultsItemView extends Backbone.View
	tagName: "a"
	template: _.template($("#template-server-search-result-item").html())

	events:
		"click": "click"

	render: ->
		if @model.pageUrl?
			@el.href = @model.pageUrl()
		fields = @model.coverViewFields()
		@$el.empty().append @template
			itemTitle: fields.title
			itemSubtitle: fields.subtitle

		$image = @$el.find(".server-search-result-item-image")
		if fields.artId?
			$image.css
				"background-image": "url(#{wavebox.apiClient.getArtUrl(fields.artId, 50)})"

		else if fields.musicBrainzId?
			console.log "assigning art for #{fields.title}"
			$image.css
				"background-image": "url(#{wavebox.apiClient.getArtistArtUrl(fields.musicBrainzId, true)})"



		this

	click: ->
		if @model.constructor.name is "Track"
			# add the song to the playlist
			wavebox.audioPlayer.playQueue.add(@model)
			return no


		return yes

module.exports = ServerSearchResultsItemView
