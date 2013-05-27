module.exports = Backbone.View.extend
	el: "#MiniPlayer"
	template: _.template($("#template-miniPlayer").html())
	events:
		"click #PlayBtn": "playBtn"
	render: ->
		temp = @template
			songName: "Young and Beautiful"
			artistName: "Lana Del Ray"
			duration: "4:23"
		@$el.empty().append temp
	
	playBtn: ->
		console.log "playBtn"
		wavebox.audioPlayer.playPause()
		if wavebox.audioPlayer.playing
			$("#PlayBtn").removeClass("Pause").addClass("Play")
		else
			$("#PlayBtn").removeClass("Play").addClass("Pause")
