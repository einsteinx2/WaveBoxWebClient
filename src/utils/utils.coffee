module.exports = class
	@formattedTimeWithSeconds: (seconds) ->
		stringTime = ""
		hrs = Math.floor(seconds / 3600)
		mins = Math.floor ((seconds - (hrs * 3600)) / 60)
		secs = Math.floor(seconds - (hrs * 3600) - (mins * 60))

		if hrs > 0 then stringTime += "#{hrs}:"
		if mins < 10 && hrs > 0 then stringTime += "0#{mins}:" else stringTime += "#{mins}:"
		if secs < 10 then stringTime += "0#{secs}" else stringTime += secs

		return stringTime
