class KeyboardShortcuts
	constructor: ->
		$(document).on "keydown", @mapKeypress

	mapKeypress: (e) =>
		switch e.keyCode
			when 32 then @spacebar()
			when 37 then @leftArrow()
			when 38 then @upArrow()
			when 39 then @rightArrow()
			when 40 then @downArrow()

	spacebar: ->
		wavebox.audioPlayer.playPause()

	leftArrow: ->
		wavebox.audioPlayer.previous()
	upArrow: ->
		wavebox.audioPlayer.volume(wavebox.audioPlayer.volume() + .1)
	rightArrow: ->
		wavebox.audioPlayer.next()
	downArrow: ->
		wavebox.audioPlayer.volume(wavebox.audioPlayer.volume() - .1)
		
module.exports = KeyboardShortcuts
