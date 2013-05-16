module.exports = Backbone.View.extend
	el: "#right"
	render: ->
		console.log "playlist render! el: #{@$el}"
		this
