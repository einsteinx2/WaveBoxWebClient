/// <reference path="../references.ts"/>
/// <reference path="../DataModel/RestClient.ts"/>

module LastFM
{
	export class WaveboxLastfm 
	{
		constructor() 
		{
			$.subscribe("player/songEnded", (e, songThatEnded) => {
				DataModel.RestClient.lfmScrobbleTrack(songThatEnded, Math.round((new Date()).getTime() / 1000));
			});

			$.subscribe("player/newSong", (e, theNewSong) => {
				DataModel.RestClient.lfmUpdateNowPlaying(theNewSong.itemId);
				//console.log("Track \"" + theNewSong.songName + "\" is now playing on last.fm")
			});
		}
	}
}