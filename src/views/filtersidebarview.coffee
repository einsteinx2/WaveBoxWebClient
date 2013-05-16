module.exports = Backbone.View.extend
	el: "#filter"
	render: ->
		console.log "playlist render! el: #{@$el}"
		this
