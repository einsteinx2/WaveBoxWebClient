/// <reference path="../references.ts"/>
/// <reference path="RestClient.ts"/>

module DataModel
{
	export class WaveboxNotifications 
	{
		constructor() 
		{
			$.subscribe("player/newSong", (e, theNewSong) => {
				var artUrl, n;
				if (typeof(window.webkitNotifications) !== "undefined" && window.webkitNotifications.checkPermission() === 0) 
				{
					artUrl = RestClient.getSongArtUrl(theNewSong, "60");
					n = window.webkitNotifications.createNotification(artUrl, theNewSong.artistName + " - " + theNewSong.songName, 'This song is now playing on WaveBox.');
					n.show();
				}
			});
		}
	}
}