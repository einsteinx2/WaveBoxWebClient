/// <reference path="../references.ts"/>

module DataModel
{
	export class RestClient
	{
		// private vars and functions go here
		private static API_ADDRESS: string = "/api/";
		private static SESSION_ID: string = localStorage.getItem("waveBoxSessionKey");
		private static itemCache: any[] = [];

		private static cacheItem(item: any): void
		{
			this.itemCache[parseInt(item.itemId, 10)] = item;
		}

		private static getCachedItem(itemId: any): any
		{
			return this.itemCache[parseInt(itemId, 10)];
		}

		public static logOut(): void
		{
			localStorage.clear();
		}

		public static authenticate(username: string, password: string, callback: any): void
		{
			console.log("Calling authenticate");
			$.ajax({
				url:	this.API_ADDRESS + "login",
				data:	"u=" + username + "&p=" + password,
				success: (data) => {
					if (data.error === null) {
						this.SESSION_ID = data.sessionId;
						console.log("sessionId: " + this.SESSION_ID);
						localStorage.setItem("waveBoxSessionKey", data.sessionId);
						callback(true);
					} else {
						callback(false, data.error);
					}
				},
				error: (XHR, textStatus, errorThrown) => {
					console.log("authenticate failed error code: " + JSON.stringify(XHR));
					callback(false);
				},
				async:	true,
				type:	'POST'
			});
		}

		public static clientIsAuthenticated(callback: any): void
		{
			// First check to see if we have a sessionId, if we do, then verify it's valid
			if (this.SESSION_ID !== undefined) 
			{
				console.log("Verifying sessionId");
				$.ajax({
					url:	this.API_ADDRESS + "status",
					data:	"s=" + this.SESSION_ID,
					success: (data) => {
						if (data.error === null) {
							console.log("sessionId is valid");
							callback(true);
						} else {
							console.log("sessionId is NOT valid, error: " + data.error);
							callback(false, data.error);
						}
					},
					error: (XHR, textStatus, errorThrown) => {
						console.log("error checking session id: " + textStatus);
						callback(false);
					},
					async:	true,
					type:	'POST'
				});
			} 
			else
			{
				callback(false);
			}
		}

		public static getArtistList(): any[] 
		{
			var artists;

			$.ajax({
				url:	this.API_ADDRESS + "artists",
				data:	"s=" + this.SESSION_ID,
				success: (data) => {
					artists = data.artists;
				},
				async:	false,
				type:	'POST'
			});

			return artists;
		}

		public static getArtistInfo(artistId: string): void 
		{
			var aId = "";
			//console.log("entered getartistinfo");
			if (artistId !== undefined) 
			{
				aId = artistId;
			} 
			else 
			{
				console.log("artist id undefined");
				$.publish("data/getArtistInfoDone", [ undefined ]);
				return;
			}

			//console.log("getting artist info");

			$.ajax({
				url:	this.API_ADDRESS + "artists/",
				data:	"s=" + this.SESSION_ID + "&id=" + aId,
				success: (data) => {
					//console.log("got artist info");
					$.publish("data/getArtistInfoDone", [ data ]);
				},
				async:	true,
				type:	'POST'
			});
		}

		// returns a single song if forItemType is songs; an array of songs if forItemType is albums.
		public static getSongList(id: any, forItemType: any): void
		{
			var songs, sId = "", call = "albums", url, i;

			if (id === undefined || forItemType === undefined) {
				$.publish("data/getSongListDone", [ undefined ]);
				return;
			} else {
				if (forItemType === "songs") {
					call = "songs";
				} else if (call !== "albums") {
					$.publish("data/getSongListDone", [ undefined ]);
					return;
				}

				call += "/";
				sId = id;
			}

			url = this.API_ADDRESS + call;

			$.ajax({
				url:	url,
				data:	"s=" + this.SESSION_ID + "&id=" + sId,
				success: (data) => {
					for (i = 0; i < data.songs.length; i++) {
						this.cacheItem(data.songs[i]);
					}

					$.publish("data/getSongListDone", [ data ]);
				},
				async:	true,
				type:	'POST'
			});
		}

		public static getFolder(folderId: string, recursive: bool, callback: any): void
		{
			var folder, url = this.API_ADDRESS + "folders", theData = "s=" + this.SESSION_ID, i;

			if (folderId !== undefined)
			{
				theData += "&id=" + folderId;
			}

			if (recursive === true) 
			{
				theData += "&recursiveMedia=1";
			}

			$.ajax({
				url:	this.API_ADDRESS + "folders",
				data:	theData,
				success: (data) => {
					if (data.songs !== undefined) {
						for (i = 0; i < data.songs.length; i++) {
							this.cacheItem(data.songs[i]);
						}
					}

					callback(true, data);
					//$.publish("data/getFolderDone", [ data.folders, data.songs ]);
				},
				error: (XHR, textStatus, errorThrown) => {
					callback(false);
				},
				async:	true,
				type:	'POST'
			});
		}

		public static getSongInfo(songId: string) 
		{
			var song, cached, url;

			if (songId === undefined) 
			{
				return;
			} 
			else 
			{
				cached = this.getCachedItem(songId);
				if (cached !== undefined) 
				{
					$.publish("data/getSongInfoDone", [ cached ]);
					return;
				}
			}

			url = this.API_ADDRESS + "songs";

			$.ajax({
				url:	url,
				data:	"s=" + this.SESSION_ID + "&id=" + songId,
				success: (data) => {
					this.cacheItem(data.songs[0]);
					$.publish("data/getSongInfoDone", [ data.songs[0] ]);
				},
				async:	false,
				type:	'POST'
			});
		}

		public static getSongStreamUrl(songId: string): string 
		{
			return this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + songId;
		}

		public static getSongUrlObject(song: any): any
		{
			var urlObj = {};

			// if the song is in one of the appropriate formats, we want to set the
			// appropriate type to stream without transcoding
			if (song.fileType === 2)
			{
				urlObj["mp3"] = this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + song.itemId;
			}
			else
			{
				urlObj["mp3"] = this.API_ADDRESS + "transcode?" + "s=" + this.SESSION_ID + "&id=" + song.itemId
								+ "&transType=" + "MP3" + "&transQuality=" + "medium";
			}

			if (song.fileType === 4)
			{
				urlObj["oga"] = this.API_ADDRESS + "stream" + "?" + "s=" + this.SESSION_ID + "&id=" + song.itemId;
			}
			else
			{
				urlObj["oga"] = this.API_ADDRESS + "transcode?" + "s=" + this.SESSION_ID + "&id=" + song.itemId
								+ "&transType=" + "OGG" + "&transQuality=" + "medium";
			}
			console.log(urlObj);
			return urlObj;
		}

		public static getSongArtUrl(song: any, size: string): string
		{
			var url = this.API_ADDRESS + "art" + "?" + "id=" + song.artId + "&" + "s=" + this.SESSION_ID, useSize;

			if (size !== undefined) 
			{
				useSize = size;
				if (Utils.isRetina()) 
				{
					useSize = parseFloat(size) * 2;
				}
				url += "&size=" + useSize;
			}
			return url;
		}

		public static lfmUpdateNowPlaying(songId: string): void 
		{
			var url = this.API_ADDRESS + "scrobble";

			$.ajax({
				url:	url,
				data:	"s=" + this.SESSION_ID + "&id=" + songId + "&action=nowplaying",
				success: (data) => {
					if (data.error === null) {
						console.log("Now playing update successful");
					} else if (data.error === "LFMNotAuthenticated") {
						window.open(data.authUrl);
					} else {
						console.log(data.error);
					}
				},
				async:	true,
				type:	'POST'
			});
		}

		public static lfmScrobbleTrack(song: any, timestamp: number) 
		{
			//console.log("song \"" + song.songName + "\" would have been scrobbled at time " + timestamp + " if the function was defined.");
			var url = this.API_ADDRESS + "scrobble";

			$.ajax({
				url:	url,
				data:	"s=" + this.SESSION_ID + "&event=" + song.itemId + "," + timestamp + "&action=submit",
				success: (data) => {
					if (data.error === null) {
						console.log("Scrobble successful (" + song.songName + ")");
					} else if (data.error === "LFMNotAuthenticated") {
						window.open(data.authUrl);
					} else {
						console.log(data.error);
					}
				},
				async:	true,
				type:	'POST'
			});
		}
	}
}