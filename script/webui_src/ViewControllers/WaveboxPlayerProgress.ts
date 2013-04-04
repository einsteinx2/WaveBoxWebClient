/// <reference path="../references.ts"/>
/// <reference path="../AudioPlayer/WaveboxPlayer.ts"/>

module ViewControllers
{
	export class WaveboxPlayerProgress
	{
		private lastPlaybackProgress: number;
		private offsetLeft: number;

		constructor()
		{
			$.subscribe("player/downloadUpdate", (e, downloadPercent) => {
				console.log("download percent " + downloadPercent);
				var containerWidth = $("#player_progress_bar").width();
				$("#player_progress_bar_buffer").width(Math.round(downloadPercent * containerWidth));
			});

			$.subscribe("player/timeUpdate", (e, elapsed, duration) => {
				this.updateUiTimeElapsed(elapsed, duration);
			});

			$.subscribe("player/newSong", (e, theNewSong) => {
				$("#player_time_duration").text(this.formattedTimeWithSeconds(theNewSong.duration));
			});

			// register the click handlers
			var seek, isMouseDown;

			seek = $.throttle(100, (percent) => {
				// Handle seeking
				console.log("setting playhead to " + percent);
				$("#jquery_jplayer_1").jPlayer("playHead", percent);
			});

			isMouseDown = false;

			$("#player_progress_bar").bind("mousedown mousemove mouseout mouseup", event => {

				var internalOffset, percent;

				if (event.type === "mousedown") {
					isMouseDown = true;
				}

				if (event.type === "mouseup") {
					isMouseDown = false;
				}

				if (isMouseDown === true) {
					internalOffset = event.pageX - $("#player_progress_bar")[0].offsetLeft;
					percent = (internalOffset / $("#player_progress_bar").width()) * 100;
					seek(percent);
				}
			});
		}

		public formattedTimeWithSeconds(seconds: number) 
		{
			var stringTime, hrs, mins, secs;

			stringTime = "";
			hrs = Math.floor(seconds / 3600);
			mins = Math.floor((seconds - (hrs * 3600)) / 60);
			secs = Math.floor(seconds - (hrs * 3600) - (mins * 60));

			if (hrs > 0) {
				stringTime += hrs + ":";
			}

			if (mins < 10 && hrs > 0) {
				stringTime += "0" + mins + ":";
			} else {
				stringTime += mins + ":";
			}

			if (secs < 10) {
				stringTime += "0" + secs;
			} else {
				stringTime += secs;
			}

			return stringTime;
		}

		public updateUiTimeElapsed(elapsedSeconds: number, durationSeconds: number) 
		{
			var formattedElapsed, currentSong, containerWidth, proposedWidth;
			if (elapsedSeconds !== undefined)
			{
				// update time marker
				formattedElapsed = this.formattedTimeWithSeconds(elapsedSeconds);
				if (formattedElapsed !== $("#player_time_elapsed").text()) 
				{
					$("#player_time_elapsed").text(formattedElapsed);
					// console.log("elapsed updated: " + formattedElapsed);
				}

				// update progress bar
				currentSong = AudioPlayer.player.currentSong();
				containerWidth = $("#player_progress_bar").width();
				proposedWidth = Math.round((elapsedSeconds / currentSong.duration) * containerWidth);
				if (elapsedSeconds !== this.lastPlaybackProgress) 
				{
					$("#player_progress_bar_playback").css("width", proposedWidth <= containerWidth ? proposedWidth : containerWidth);
					this.lastPlaybackProgress = elapsedSeconds;
					//console.log("playback bar width updated: " + Math.round((elapsedSeconds / currentSong.duration) * containerWidth));
				}
			}
		}
	}
}