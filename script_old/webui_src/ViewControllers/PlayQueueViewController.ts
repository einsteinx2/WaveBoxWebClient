/// <reference path="../references.ts"/>
/// <reference path="../AudioPlayer/WaveboxPlayer.ts"/>

module ViewControllers
{
	export class PlayQueueViewController
	{
		constructor()
		{
			// Double click to start playing item
			$(".sidebar_playlistItem").live("dblclick", function () {
				var index = $(this).index();
				AudioPlayer.player.setNowPlayingIndex(index);
			});

			// Highlight the currently playing item
			$.subscribe("player/newSong", () => { 
				this.updateCurrentPlayingMarker();
			});
			$.subscribe("player/playlistContentsFinishedRendering", () => {
				this.updateCurrentPlayingMarker();
			});
		}

		private resetBackgroundColors()
		{
			$(".sidebar_playlistItem").removeClass("sidebar_playlistItem_nowplaying");
		}

		private updateCurrentPlayingMarker() 
		{
			this.resetBackgroundColors();
			$("#pli" + AudioPlayer.player.currentIndex()).addClass("sidebar_playlistItem_nowplaying");
		}
	}
}