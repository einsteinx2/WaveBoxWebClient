class KeyboardShortcuts
	constructor: ->
		$(document).on "keydown", @mapKeypress

	mapKeypress: (e) =>
		console.log e.keyCode
		if document.activeElement.tagName isnt "INPUT"
			if e.keyCode is 32
				@spacebar()
			if e.keyCode is 37
				@leftArrow()
			if e.keyCode is 38
				@upArrow()
			if e.keyCode is 39
				@rightArrow()
			if e.keyCode is 40
				@downArrow()
			if e.keyCode is 70 and (e.metaKey or e.ctrlKey)
				e.preventDefault()
				if e.shiftKey
					@cmdShiftF()
				else
					@cmdF()
		else
			if e.keyCode is 27
				document.activeElement.blur()

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

	cmdShiftF: ->
		wavebox.appController.mainView.$el.find(".page-search-textbox").last().focus()

	cmdF: ->
		$(".server-search-input").focus()

module.exports = KeyboardShortcuts
