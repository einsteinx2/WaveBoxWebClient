/// <reference path="references.ts"/>
/// <reference path="../DataModel/RestClient.ts"/>
/// <reference path="jquery.d.ts" />


module AudioPlayer
{
	export var player;

	var self;

	export var setup = function () {
		player = new WaveboxPlayer();
		self = player;
	};

	export class WaveboxPlayer
	{
		public playing: bool;
		public shuffleEnabled: bool;
		public shuffledPlaylist: any[];
		public normalOrderPlaylist: any[];
		public repeatMode: string;
		public elapsedTime: number;
		public playlistComingUp: any[];

		private titleTempStore: string;
		private preferredCodec: string;

		constructor()
		{
			this.playing = false;
			this.shuffleEnabled = false;
			this.shuffledPlaylist = [];
			this.normalOrderPlaylist = [];
			this.repeatMode = "off";
			this.elapsedTime = 0;
			this.playlistComingUp = [];  // The "now playing" playlist
			this.preferredCodec = "mp3";

			// subscribe to needed events
			$.subscribe("player/songEnded", () => {
				this.next(null);
			});

			// register the click handlers
			$(".playerButtonShuffle").click(this.shuffle);
			$(".playerButtonRepeat").click(this.repeat);
			$(".playerButtonNext").click(this.next);
			$(".playerButtonPrevious").click(this.previous);
			$(".playerButtonPlayPause").click(this.playPause);
			$("#clearPlaylist").click(this.clearPlaylist);

			// setup jplayer
			$("#jquery_jplayer_1").jPlayer({
				ready: () => {
				},
				ended: () => {
					var song = this.currentSong();
					$.publish("player/songEnded", [ song ]);
				},
				play: () => {
					//console.log("playing true");
					this.isPlaying(true);
				},
				pause: () => {
					//console.log("playing false");
					this.isPlaying(false);
				},
				stop: () => {
					//console.log("stop called.");
				},
				progress: (e) => {
					//console.log("status: " + JSON.stringify(e.jPlayer.status));
					var seekPercent = e.jPlayer.status.seekPercent / 100; // Turn it into a percent
					$.publish("player/downloadUpdate", [ seekPercent ]);
				},
				timeupdate: (e) => {
					//console.log("status: " + JSON.stringify(e.jPlayer.status));
					$.publish("player/timeUpdate", [ e.jPlayer.status.currentTime, e.jPlayer.status.duration ]);
				},
				volumechange: (e) => {
					$.publish("player/volumeChange", [ e.jPlayer.options.volume, e.jPlayer.options.muted ]);
				},
				swfPath: "/swf/",
				supplied: "mp3, oga",
				solution: "html, flash"
			});
		}

		private createJPlayerInstanceWithSupplyString(codecPreference: string): void
		{
			// setup jplayer
			$("#jquery_jplayer_1").jPlayer({
				ready: () => {
				},
				ended: () => {
					var song = this.currentSong();
					$.publish("player/songEnded", [ song ]);
				},
				play: () => {
					//console.log("playing true");
					this.isPlaying(true);
				},
				pause: () => {
					//console.log("playing false");
					this.isPlaying(false);
				},
				stop: () => {
					//console.log("stop called.");
				},
				progress: (e) => {
					//console.log("status: " + JSON.stringify(e.jPlayer.status));
					var seekPercent = e.jPlayer.status.seekPercent / 100; // Turn it into a percent
					$.publish("player/downloadUpdate", [ seekPercent ]);
				},
				timeupdate: (e) => {
					//console.log("status: " + JSON.stringify(e.jPlayer.status));
					$.publish("player/timeUpdate", [ e.jPlayer.status.currentTime, e.jPlayer.status.duration ]);
				},
				volumechange: (e) => {
					$.publish("player/volumeChange", [ e.jPlayer.options.volume, e.jPlayer.options.muted ]);
				},
				swfPath: "/swf/",
				supplied: codecPreference,
				solution: "html, flash"
			});
		}
		
		private saveToLocalStorage(): void
		{
			// Save to local storage if available
			if (Storage !== undefined) 
			{
				localStorage.setItem("playlistComingUp", JSON.stringify(self.playlistComingUp));
				//console.log("setting playlistComingUp: " + localStorage.playlistComingUp);
			}
		}

		private setPlayerSong(song: any, shouldPlay: bool): void
		{
			var incomingCodec = self.preferredMediaExtensionForSong(song);
			console.log("New song type: " + incomingCodec);

			if(incomingCodec !== "INCOMPATIBLE")
			{
				// if jPlayer's preferred codec is not the codec we have chosen, we need to
				// re-init jPlayer with the 'supplied' string flipped.
				if(self.preferredCodec !== incomingCodec)
				{
					// destroy the existing jPlayer object
					$("#jquery_jplayer_1").jPlayer("destroy");

					// for checking in the future if we need to destroy the jPlayer object
					self.preferredCodec = incomingCodec;

					// re-init jPlayer preferring the new incoming codec
					if(incomingCodec === "mp3")
					{
						self.createJPlayerInstanceWithSupplyString("mp3, oga");
					}
					else 
					{
						self.createJPlayerInstanceWithSupplyString("oga, mp3");
					}
				}
				// get url object for song
				var urlObject = DataModel.RestClient.getSongUrlObject(song);

				// set the media on the jPlayer instance
				$("#jquery_jplayer_1").jPlayer("setMedia", urlObject);

				// play the song if appropriate
				if (shouldPlay !== false) 
				{
					$("#jquery_jplayer_1").jPlayer("play");
				}

				// save to local storage
				self.saveToLocalStorage();

				// notify listeners that a new song has been loaded
				$.publish("player/newSong", [ song ]);
			}
			else
			{
				console.log("unable to play");
				console.log(song);
				self.next();
			}
		}

		private preferredMediaExtensionForSong(song: any): string
		{
			switch(song.fileType)
			{
				case 1: return "oga"; break;					// AAC
				case 2: return "mp3"; break; 					// MP3
				case 3: return "oga"; break;					// MPC
				case 4: return "oga"; break;					// OGG
				case 5: return "oga"; break;					// WMA
				case 6: return "oga"; break;					// ALAC
				case 7: return "oga"; break;					// APE
				case 8: return "oga"; break;					// FLAC
				case 9: return "oga"; break;					// WV
				case 10: return "oga"; break;					// MP4
				case 11: return "INCOMPATIBLE"; break;			// MKV
				case 12: return "INCOMPATIBLE"; break;			// AVI
				case 2147483647: return "INCOMPATIBLE"; break;	// UNKNOWN
				default: return "INCOMPATIBLE";
			}
		}

		public loadFromLocalStorage(): void
		{
			// Load from local storage if available
			if (Storage !== undefined) 
			{
				if (localStorage.getItem("playlistComingUp") !== undefined && localStorage.getItem("playlistComingUp") !== null) 
				{
					self.playlistComingUp = JSON.parse(localStorage.getItem("playlistComingUp"));
					//console.log("playlistComingUp: " + playlistComingUp);
				}
			}
			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public setNowPlayingIndex(index: number): void
		{
			if (index !== self.playlistComingUp.NowPlayingIndex && index >= 0 && index < self.playlistComingUp.length) 
			{
				self.playlistComingUp.NowPlayingIndex = index;
				self.setPlayerSong(self.playlistComingUp[self.playlistComingUp.NowPlayingIndex], true);
			}
		}

		public moveItem(startIndex: number, endIndex: number): void
		{
			// Sanity check
			if (startIndex !== undefined && endIndex !== undefined &&
				startIndex >= 0 && startIndex < self.playlistComingUp.length &&
				endIndex >= 0 && endIndex < self.playlistComingUp.length &&
				startIndex !== endIndex)
			{
				var item = self.playlistComingUp[startIndex];

				// Remove the original
				self.playlistComingUp.splice(startIndex, 1);

				// Move it or lose it
				self.playlistComingUp.splice(endIndex, 0, item);

				// Update the now playing index for the moved item
				if(startIndex > this.currentIndex() && endIndex <= this.currentIndex())
				{
					this.playlistComingUp.NowPlayingIndex++;
				}
				else if(startIndex < this.currentIndex() && endIndex >= this.currentIndex())
				{
					this.playlistComingUp.NowPlayingIndex--;
				}
				else if(startIndex == this.currentIndex())
				{
					this.playlistComingUp.NowPlayingIndex = endIndex;
				}

				self.saveToLocalStorage();
				$.publish("player/playlistContentsChanged", [ this.playlistComingUp ]);
			}
		}

		public addToPlaylist(item: any, index: number): void 
		{
			var insertIndex;

			if (item === undefined) 
			{
				return;
			} 
			else if (index !== undefined)
			{
				insertIndex = index;
			} 
			else 
			{
				insertIndex = self.playlistComingUp.length;
			}

			if (insertIndex < self.playlistComingUp.length) 
			{
				// we need shift everything to the right to make room for the new item
				self.playlistComingUp.splice(insertIndex, 0, item);
			} 
			else 
			{
				self.playlistComingUp.push(item);
			}

			if (self.shuffleEnabled === true) 
			{
				self.normalOrderPlaylist.push(item);
			}

			// If the playlist was empty before we started, we need to set update Now Playing and set
			// the media for the player so that it will play if the user presses the play button.
			if (self.playlistComingUp.length === 1) 
			{
				self.playlistComingUp.NowPlayingIndex = 0;
				self.setPlayerSong(item, false);
			}

			self.saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public addArrayToPlaylist(itemsArray: any[], index: number): void
		{
			var insertIndex, a, b;

			if (!$.isArray(itemsArray)) 
			{
				console.log("itemsArray: " + JSON.stringify(itemsArray));
				return;
			} 
			else if (index !== undefined) 
			{
				insertIndex = index;
			} 
			else {
				insertIndex = self.playlistComingUp.length;
			}

			if (insertIndex < self.playlistComingUp.length) 
			{
				// we need shift everything to the right to make room for the new item
				//this.playlistComingUp.splice(insertIndex, 0, item);
				Array.prototype.splice.apply(self.playlistComingUp, [insertIndex, 0].concat(itemsArray));
			} 
			else 
			{
				a = self.playlistComingUp.slice(0);
				b = itemsArray.slice(0);
				//a.splice.apply(b, [b.length, 9e9]);

				self.playlistComingUp = a.concat(b);
				//this.playlistComingUp.push.apply(itemsArray);
			}

			if (self.shuffleEnabled === true) 
			{
				self.normalOrderPlaylist.push(self.playlistComingUp, itemsArray);
			}

			// If the playlist was empty before we started, we need to set update Now Playing and set
			// the media for the player so that it will play if the user presses the play button.
			if (self.playlistComingUp.length === 1) 
			{
				self.playlistComingUp.NowPlayingIndex = 0;
				self.setPlayerSong(itemsArray[0], false);
			}

			self.saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public removeFromPlaylist(index: number): void
		{
			if (index === undefined)
			{
				return;
			}

			if (self.playlistComingUp[index] !== undefined) 
			{
				self.playlistComingUp.splice(index, 1);
			}

			self.saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public clearPlaylist(): void
		{
			self.playlistComingUp = [];
			self.normalOrderPlaylist = [];
			self.shuffledPlaylist = [];
			
			if(self.shuffleEnabled === true)
			{
				self.shuffle();
			}

			if(self.playing === true)
			{
				$("#jquery_jplayer_1").jPlayer("stop", 0);
				self.playing = undefined;
			}

			$("#nowPlaying_songList").empty();
			self.saveToLocalStorage();
			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public next(e: any): void
		{
			//console.log("next - NowPlayingIndex = " + this.playlistComingUp.NowPlayingIndex);
			if (self.repeatMode === "repeatOne" && e.type !== "click")
			{
				$("#jquery_jplayer_1").jPlayer("play", 0);
				return;
			} 
			else if (self.playlistComingUp.length > self.playlistComingUp.NowPlayingIndex + 1) 
			{
				self.playlistComingUp.NowPlayingIndex++;
				self.setPlayerSong(self.playlistComingUp[self.playlistComingUp.NowPlayingIndex], true);
			} 
			else if (self.repeatMode === "repeatAll" && self.playlistComingUp.length <= self.playlistComingUp.NowPlayingIndex + 1) 
			{
				self.playlistComingUp.NowPlayingIndex = 0;
				self.setPlayerSong(self.playlistComingUp[self.playlistComingUp.NowPlayingIndex], true);
			} 
			else 
			{
				document.title = "WaveBox";
				$("#jquery_jplayer_1").jPlayer("stop", 0);
				self.playing = undefined;
			}
		}

		public previous(): void
		{
			//console.log("previous");
			if (self.elapsedTime > 2 || self.playlistComingUp.NowPlayingIndex === 0) 
			{
				$("#jquery_jplayer_1").jPlayer("play", 0);
			} 
			else 
			{
				self.playlistComingUp.NowPlayingIndex--;
				self.setPlayerSong(self.playlistComingUp[self.playlistComingUp.NowPlayingIndex], true);
			}
		}
		
		public playPause(): void
		{
			//console.log("playPause");

			// ask the user if we're allowed to send notifications
			if(typeof(window.webkitNotifications) !== "undefined")
			{
				var permission = window.webkitNotifications.checkPermission();
				console.log("permission" + permission);
				if (permission !== 0)
				{
					window.webkitNotifications.requestPermission(() => {
						console.log("Notification permission granted");
					});
				}
			}

			if (self.playing)
			{
				$("#jquery_jplayer_1").jPlayer("pause");
				self.titleTempStore = document.title;
				document.title = "WaveBox :: Paused";
			}
			else
			{
				if (self.playing === false && self.playing !== undefined)
				{
					document.title = self.titleTempStore;
					$("#jquery_jplayer_1").jPlayer("play");
				}
				else
				{
					$("#jquery_jplayer_1").jPlayer("play", 0);
					//$.publish("player/newSong", [ playlistComingUp[playlistComingUp.NowPlayingIndex] ]);
				}
			}
		}
			
		public shuffle(): void
		{
			if (self.shuffleEnabled === true) 
			{
				// informative things
				//console.log("shuffle off");
				self.shuffleEnabled = false;

				// adjust the now playing index
				var currSong = self.currentSong();

				if(currSong !== undefined)
				{
					self.normalOrderPlaylist.NowPlayingIndex = currSong.preShuffleIndex === undefined ? self.playlistComingUp.NowPlayingIndex : currSong.preShuffleIndex;
				}
				// swap the normal order playlist back in
				self.playlistComingUp = self.normalOrderPlaylist;

				// update the shuffle button
				$(".playerButtonShuffle").html("Shuffle(Off)");
			} 
			else 
			{
				// informative things
				//console.log("shuffle on");
				self.shuffleEnabled = true;

				// copy the normal order playlist and its now playing index, then shuffle it
				self.shuffledPlaylist = self.playlistComingUp.slice();
				if(self.currentSong() !== undefined)
				{
					self.shuffledPlaylist.NowPlayingIndex = self.playlistComingUp.NowPlayingIndex;
				}
				self.shuffledPlaylist.shuffle();

				// create a reference to the normal order playlist
				self.normalOrderPlaylist = self.playlistComingUp;

				// swap the two out
				self.playlistComingUp = self.shuffledPlaylist;

				// update the shuffle button
				$(".playerButtonShuffle").html("Shuffle(On)");
			}
			$.publish("player/playlistContentsChanged", [ self.playlistComingUp ]);
		}

		public repeat(): void
		{
			if (self.repeatMode === "off") 
			{
				self.repeatMode = "repeatOne";
				$(".playerButtonRepeat").html("Repeat(1)");
			} 
			else if (self.repeatMode === "repeatOne") 
			{
				self.repeatMode = "repeatAll";
				$(".playerButtonRepeat").html("Repeat(All)");
			} 
			else 
			{
				$(".playerButtonRepeat").html("Repeat(Off)");
				self.repeatMode = "off";
			}
			//console.log("repeatMode: " + this.repeatMode);
		}

		public isPlaying(set: bool): bool
		{
			if (set === true || set === false) 
			{
				self.playing = set;
			}

			return self.playing;
		}

		public currentSong(): any
		{
			return self.playlistComingUp[self.playlistComingUp.NowPlayingIndex];
		}

		public currentIndex(): any
		{
			return self.playlistComingUp.NowPlayingIndex;
		}

		public playlistCount(): any
		{
			return self.playlistComingUp.length;
		}
	}
}