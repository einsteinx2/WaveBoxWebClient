window.isRetina = function () {
	return this.devicePixelRatio > 1 ? true : false;
};

Array.prototype.shuffle = function () {
	// iterate over the array and assign pre-shuffle indices
	var temp, j, i = 0;
	while (i < this.length) {
		this[i].preShuffleIndex = i;
		i++;
	}

	i = this.length;
	while (--i) {
		// generate a random number
		j = Math.floor(Math.random() * (i + 1));

		// swap the item at the current index and the item at the randomly generated number
		temp = this[i];
		this[i] = this[j];
		this[j] = temp;

		// if the currently playing song is involved in the swap, adjust the NowPlayingIndex to reflect that.
		if (this.NowPlayingIndex === i) {
			this.NowPlayingIndex = j;
		} else if (this.NowPlayingIndex === j) {
			this.NowPlayingIndex = i;
		}
	}

    console.log("NowPlayingIndex is now: " + this.NowPlayingIndex);

    return this; // for convenience, in case we want a reference to the array
};

// Object prototypes
var waveboxData, waveboxFolderContextViewController, playQueueViewController, browseViewController, controller, waveboxPlayer, waveboxPlayerProgress, waveboxVolumeController, waveboxLastfm, waveboxNotifications;
/*
	Data model
*/
waveboxData = (function () {
	"use strict";

	// private vars and functions go here
	var API_ADDRESS = "/api/", SESSION_ID = localStorage.getItem("waveBoxSessionKey"), itemCache = [], cacheItem, getCachedItem;

	cacheItem = function (item) {
		itemCache[parseInt(item.itemId, 10)] = item;
	};

	getCachedItem = function (itemId) {
		return itemCache[parseInt(itemId, 10)];
	};

	// public vars and functions go in this object literal
	return {
		logOut: function () {
			localStorage.clear();
		},
		authenticate: function (username, password, callback) {
			console.log("Calling authenticate");
			$.ajax({
				url:	API_ADDRESS + "login",
				data:	"u=" + username + "&p=" + password,
				success: function (data) {
					if (data.error === null) {
						SESSION_ID = data.sessionId;
						console.log("sessionId: " + SESSION_ID);
						localStorage.setItem("waveBoxSessionKey", data.sessionId);
						callback(true);
					} else {
						callback(false, data.error);
					}
				},
				error: function (XHR, textStatus, errorThrown) {
					console.log("authenticate failed error code: " + JSON.stringify(XHR));
					callback(false);
				},
				async:	true,
				type:	'POST'
			});
		},

		clientIsAuthenticated: function (callback) {
			// First check to see if we have a sessionId, if we do, then verify it's valid
			if (SESSION_ID !== undefined) {
				console.log("Verifying sessionId");
				$.ajax({
					url:	API_ADDRESS + "status",
					data:	"s=" + SESSION_ID,
					success: function (data) {
						if (data.error === null) {
							console.log("sessionId is valid");
							callback(true);
						} else {
							console.log("sessionId is NOT valid, error: " + data.error);
							callback(false, data.error);
						}
					},
					error: function (XHR, textStatus, errorThrown) {
						console.log("error checking session id: " + textStatus);
						callback(false);
					},
					async:	true,
					type:	'POST'
				});
			} else {
				callback(false);
			}
		},

		getArtistList: function () {
			var artists;

			$.ajax({
				url:	API_ADDRESS + "artists",
				data:	"s=" + SESSION_ID,
				success: function (data) {
					artists = data.artists;
				},
				async:	false,
				type:	'POST'
			});

			return artists;
		},

		getArtistInfo: function (artistId) {
			var aId = "";
			//console.log("entered getartistinfo");
			if (artistId !== undefined) {
				aId = artistId;
			} else {
				console.log("artist id undefined");
				$.publish("data/getArtistInfoDone", [ undefined ]);
				return;
			}

			//console.log("getting artist info");

			$.ajax({
				url:	API_ADDRESS + "artists/",
				data:	"s=" + SESSION_ID + "&id=" + aId,
				success: function (data) {
					//console.log("got artist info");
					$.publish("data/getArtistInfoDone", [ data ]);
				},
				async:	true,
				type:	'POST'
			});


		},

		// returns a single song if forItemType is songs; an array of songs if forItemType is albums.
		getSongList: function (id, forItemType) {
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

			url = API_ADDRESS + call;

			$.ajax({
				url:	url,
				data:	"s=" + SESSION_ID + "&id=" + sId,
				success: function (data) {
					for (i = 0; i < data.songs.length; i++) {
						cacheItem(data.songs[i]);
					}

					$.publish("data/getSongListDone", [ data ]);
				},
				async:	true,
				type:	'POST'
			});

			return;
		},

		getFolder: function (folderId, recursive, callback) {

			var folder, url = API_ADDRESS + "folders", theData = "s=" + SESSION_ID, i;

			if (folderId !== undefined) {
				theData += "&id=" + folderId;
			}

			if (recursive === true) {
				theData += "&recursiveMedia=1";
			}

			$.ajax({
				url:	API_ADDRESS + "folders",
				data:	theData,
				success: function (data) {
					if (data.songs !== undefined) {
						for (i = 0; i < data.songs.length; i++) {
							cacheItem(data.songs[i]);
						}
					}

					callback(true, data);
					//$.publish("data/getFolderDone", [ data.folders, data.songs ]);
				},
				error: function (XHR, textStatus, errorThrown) {
					callback(false);
				},
				async:	true,
				type:	'POST'
			});

		},

		getSongInfo: function (songId) {
			var song, cached, url;

			if (songId === undefined) {
				return;
			} else {
				cached = getCachedItem(songId);
				if (cached !== undefined) {
					$.publish("data/getSongInfoDone", [ cached ]);
					return;
				}
			}

			url = API_ADDRESS + "songs";

			$.ajax({
				url:	url,
				data:	"s=" + SESSION_ID + "&id=" + songId,
				success: function (data) {
					cacheItem(data.songs[0]);
					$.publish("data/getSongInfoDone", [ data.songs[0] ]);
				},
				async:	false,
				type:	'POST'
			});

			return;
		},

		getSongStreamUrl: function (songId) {
			return API_ADDRESS + "stream" + "?" + "s=" + SESSION_ID + "&id=" + songId;
		},

		getSongArtUrl: function (song, size) {

			var url = API_ADDRESS + "art" + "?" + "id=" + song.artId + "&" + "s=" + SESSION_ID, useSize;

			if (size !== undefined) {
				useSize = size;
				if (window.isRetina()) {
					useSize = parseFloat(size) * 2;
				}
				url += "&size=" + useSize;
			}
			return url;
		},

		lfmUpdateNowPlaying: function (songId) {
			var url = API_ADDRESS + "scrobble";

			$.ajax({
				url:	url,
				data:	"s=" + SESSION_ID + "&id=" + songId + "&action=nowplaying",
				success: function (data) {
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
		},

		lfmScrobbleTrack: function (song, timestamp) {
			//console.log("song \"" + song.songName + "\" would have been scrobbled at time " + timestamp + " if the function was defined.");
			var url = API_ADDRESS + "scrobble";

			$.ajax({
				url:	url,
				data:	"s=" + SESSION_ID + "&event=" + song.itemId + "," + timestamp + "&action=submit",
				success: function (data) {
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
	};
}());

/*
	UI Controller
*/

waveboxFolderContextViewController = (function () {

	var formattedTimeWithSeconds, publicMembers;

	publicMembers = {

		updateWithArtistList: function () {

		},

		updateWithArtist: function (artist) {

		},

		updateWithAlbum: function (album) {

		},

		updateWithFolder: function (folderInfo) {
			var cf, artUrl, fNum, sNum, vNum, mediaCountString, totalDuration;
			cf = folderInfo.containingFolder;
			artUrl = waveboxData.getSongArtUrl(cf);
			$("#contextInfoImg").attr("src", artUrl);
			$("#contextInfoTitle").text(cf.folderName);

			// grab number of folders, songs, videos.  Assemble the needed string, and
			// update the view.
			fNum = folderInfo.folders.length > 0 ? folderInfo.folders.length : "No";
			sNum = folderInfo.songs.length > 0 ? folderInfo.songs.length : "no";
			vNum = folderInfo.videos.length > 0 ? folderInfo.videos.length : "no";
			mediaCountString = fNum + " folders, " + sNum + " songs, " + vNum + " videos";
			$("#contextInfoSubTitle").text(mediaCountString);



			// calculate the total duration of all media items (songs for now)
			// show the duration view if it's more than 0 seconds
			totalDuration = 0;
			folderInfo.songs.forEach(function (element, index, array) {
				totalDuration += element.duration;
			});

			if (totalDuration > 0) {
				$("#contextInfoTotalLength").text("Total duration: " + formattedTimeWithSeconds(totalDuration));
				$("#contextInfoTotalLength").show();
			} else {
				$("#contextInfoTotalLength").hide();
			}
		}
	};

	formattedTimeWithSeconds = function (seconds) {
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
	};

	return publicMembers;
}());

playQueueViewController = (function () {

	var publicMembers, resetBackgroundColors, updateCurrentPlayingMarker;
	publicMembers = { };

	$(function () {

		// Double click to start playing item
		$(".sidebar_playlistItem").live("dblclick", function () {
			var index = $(this).index();
			waveboxPlayer.setNowPlayingIndex(index);
		});
	});

	resetBackgroundColors = function () {
		$(".sidebar_playlistItem").removeClass("sidebar_playlistItem_nowplaying");
	};

	updateCurrentPlayingMarker = function () {
		resetBackgroundColors();
		$("#pli" + waveboxPlayer.currentIndex()).addClass("sidebar_playlistItem_nowplaying");
	};

	// Highlight the currently playing item
	$.subscribe("player/newSong", updateCurrentPlayingMarker);
	$.subscribe("player/playlistContentsFinishedRendering", updateCurrentPlayingMarker);

	return publicMembers;
}());

browseViewController = (function () {

	var viewStack, viewStackIndex, viewMode, publicMembers, i;

	viewStack = [];
	viewStackIndex = 0;

	publicMembers = {
		clearViews: function () {
			for (i = 1; i <= viewStackIndex; i++) {
				$("#browseView" + i).remove();
			}

			viewStackIndex = 0;
			viewStack = [];
		},
		pushView: function (domElement, viewModeOfView) {

			console.log("push view");

			if (viewModeOfView !== viewMode) {
				viewMode = viewModeOfView;
				publicMembers.clearViews();
			}

			// increment index
			viewStackIndex++;
			console.log("index: " + viewStackIndex);

			var newDiv = document.createElement("div");
			$(newDiv).attr("id", "browseView" + viewStackIndex);
			$(newDiv).html(domElement);

			// append element to DOM
			$("#browseViewContainer").append(newDiv);

			// push view reference onto viewStack
			viewStack[viewStackIndex] = ("#browseView" + viewStackIndex);
			console.log(viewStack);

			// hide currently shown DOM element
			$("#browseView" + (viewStackIndex - 1)).hide();

			// show pushed DOM element
			$("#browseView" + viewStackIndex).show();

			// publish ui/browseViewDidChange
			$.publish("ui/browseViewDidChange", "#browseView" + viewStackIndex);

			// Show the back button
			if (viewStackIndex > 1) {
				$("#backButton").show();
			}
		},
		popView: function () {

			// return if we're at the root because we don't want to pop the last view off the stack
			if (viewStackIndex === 1) {
				return;
			}

			// hide currently shown element
			$("#browseView" + viewStackIndex).hide();

			// show previous element
			$("#browseView" + (viewStackIndex - 1)).show();

			// remove current element from the DOM
			$("#browseView" + viewStackIndex).remove();

			// pop reference off of viewStack
			viewStack.splice(viewStackIndex, 1);

			// subtract from the index
			viewStackIndex--;

			// publish ui/browseViewDidChange
			$.publish("ui/browseViewDidChange", "#browseView" + viewStack.length - 1);

			// Hide the back button if necessary
			if (viewStackIndex === 1) {
				$("#backButton").hide();
			}
		},
		currentViewSelector: function () {
			return viewStack[viewStackIndex];
		}
	};

	$(function () {
		$("#backButton").hide();
		$("#backButton").click(function () {
			//console.log("popping view");
			publicMembers.popView();
		});
	});

	return publicMembers;
}());

controller = (function () {
	"use strict";

	// templates
	var publicMembers, playQueueTemplate, playQueueCellTemplate, artistsTemplate, albumsTemplate, songsTemplate, folderTemplate, loginTemplate, updateNowPlaying, renderPlaylist, showRootFolder;

	updateNowPlaying = function (e, song) {
		if (song === undefined) {
			$(".nowPlaying_artContainer").fadeOut("fast");
			$(".nowPlaying_songInfoContainer").fadeOut("fast");
			return;
		}

		$(".nowPlaying_artContainer").fadeOut("fast");
		$(".nowPlaying_songInfoContainer").fadeOut("fast", function () {

			var theArt = new Image();
			theArt.onerror = function () {
				//console.log("error loading art");
				theArt.src = "/img/art_default.png";
			};

			theArt.src = waveboxData.getSongArtUrl(song, 60);
			theArt.className = "nowPlaying_art";

			$("#nowPlaying_art").empty().append(theArt);

			$("#nowPlaying_song").html(song.songName);
			$("#nowPlaying_artist").html(song.artistName);
			$("#nowPlaying_album").html(song.albumName);

			document.title = "WaveBox :: " + song.artistName + " - " + song.songName;

			$(".nowPlaying_artContainer").fadeIn("fast");
			$(".nowPlaying_songInfoContainer").fadeIn("fast");
		});
	};

	// Public properties and methods
	publicMembers = {
		logOut: function () {
			console.log("logout clicked");
			waveboxData.logOut();
			publicMembers.showLogin();
		},
		// Playlist

		// Media library
		showArtists: function () {
			var artists, html, id;
			artists = waveboxData.getArtistList();
			html = artistsTemplate.render({artists: artists});
			browseViewController.pushView(html, "tag");
			$("#artistList").delegate(".artistListItem", "click", function (e) {
				id = $(this).attr("id").substr(1);
				$.subscribe("data/getArtistInfoDone", function (e, info) {
					if (info !== undefined) {
						//console.log("artist id: " + info.artistId);
						$.publish("ui/artistWasClicked", [ info ]);
					}
					$.unsubscribe("data/getArtistInfoDone");
				});
				waveboxData.getArtistInfo(id);
			});

		},
		showArtistAlbums: function (e, artistInfo) {
			var albums, html, id;
			albums = artistInfo.albums;
			html = albumsTemplate.render({albums: albums});
			browseViewController.pushView(html, "tag");
			$("#albumList").delegate(".albumListItem", "click", function (e) {
				id = $(this).attr("id").substr(1);
				$.subscribe("data/getSongListDone", function (e, info) {
					if (info !== undefined) {
						//console.log("album id: " + id);
						$.publish("ui/albumWasClicked", [ info ]);
						//console.log("albumWasClicked published");
						$.unsubscribe("data/getSongListDone");
					}
				});
				waveboxData.getSongList(id, "albums");
			});
		},
		showAlbumSongs: function (e, albumInfo) {
			//console.log("showAlbumSongs");
			var songs, html, id;
			songs = albumInfo.songs;
			html = songsTemplate.render({songs: songs});
			browseViewController.pushView(html, "tag");
			$("#songList").delegate(".songListItem", "click", function (e) {
				id = $(this).attr("id").substr(1);
				//console.log("song id: " + id);

				$.subscribe("data/getSongInfoDone", function (e, song) {
					waveboxPlayer.clearPlaylist();
					waveboxPlayer.addToPlaylist(song);
					waveboxPlayer.playPause();
					$.unsubscribe("data/getSongInfoDone");
				});
				waveboxData.getSongInfo(id);
			});

			$("#songList").delegate(".songListItemAdd", "click", function (e) {
				var id = $(this).attr("id").substr(3);
				//console.log("song id: " + id);

				$.subscribe("data/getSongInfoDone", function (e, song) {
					waveboxPlayer.addToPlaylist(song);
					$.unsubscribe("data/getSongInfoDone");
				});
				waveboxData.getSongInfo(id);
			});
		},
		showFolder: function (e, data) {

			var html;
			if (e === undefined) {
				showRootFolder();
				return;
			} else if (e !== null) {
				waveboxFolderContextViewController.updateWithFolder(data);
			}


			html = folderTemplate.render({mediaItems: data.songs, folders: data.folders});
			browseViewController.pushView(html, "folder");
			//console.log(browseViewController.currentViewSelector());

			$(browseViewController.currentViewSelector()).delegate(".folderListItemAdd", "click", function (e) {
				var id = $(this).attr("id").substr(4);
				//console.log("folder id: " + id);

				waveboxData.getFolder(id, true, function (success, data) {
					waveboxPlayer.addArrayToPlaylist(data.songs);
				});
			});

			$(browseViewController.currentViewSelector()).delegate(".folderListItem", "click", function (e) {
				var id = $(this).attr("id").substr(1);
				//console.log("folder id: " + id);

				waveboxData.getFolder(id, false, function (success, data) {
					if (success) {
						$.publish("ui/folderWasClicked", [ data ]);
					}
				});
			});

			$(browseViewController.currentViewSelector()).delegate(".songListItem", "click", function (e) {
				// Get the data right from the dom instead of doing a network call
				waveboxPlayer.clearPlaylist();
				waveboxPlayer.addToPlaylist(JSON.parse(decodeURIComponent($(this).parent().parent().data("mediaitem"))));
				waveboxPlayer.playPause();
			});

			$(browseViewController.currentViewSelector()).delegate(".songListItemAdd", "click", function (e) {
				// Get the data right from the dom instead of doing a network call
				waveboxPlayer.addToPlaylist(JSON.parse(decodeURIComponent($(this).parent().parent().data("mediaitem"))));
			});

			/*
			$('tr.folderRow:visible').livequery(function(event) {
				console.log("folder row shown");
				$(this).draggable({
					revert: "invalid",
					helper: function () {
						return $(playQueueCellTemplate.render({"itemName": folders[$(this).index()-1].folderName, "index": 0}));
					},
					//helper: "clone",
					connectToSortable: "#playQueueList"
				});
			});
			$('tr.folderRow:hidden').livequery(function(event) {
				console.log("folder row hidden, this " + $(this));
				$(this).draggable().draggable("destroy");
			});*/

			// Handle dragging folder to the play queue
			$("tr.folderRow").draggable({
				revert: "invalid",
				helper: function () {
					return $(playQueueCellTemplate.render({"itemName": data.folders[$(this).index() - 1].folderName, "index": 0}));
				},
				//helper: "clone",
				connectToSortable: "#playQueueList"
			});

			// Handle dragging song to the play queue
			$("tr.songRow").draggable({
				revert: "invalid",
				helper: function () {
					return $(playQueueCellTemplate.render({"itemName": data.songs[$(this).index() - 1].songName, "index": 0}));
				},
				//helper: "clone",
				connectToSortable: "#playQueueList"
			});
		},
		showLogin: function () {
			console.log("showing login");

			// Hide everything on the screen
			$("#body_container").hide();

			// Show the login box
			var html = loginTemplate.render();
			$("body").append(html);

			// Setup the onclick handler for the form
			$("#loginButton").click(function () {
				var username, password;

				username = $("#loginUsername").val();
				password = $("#loginPassword").val();
				waveboxData.authenticate(username, password, function (success) {
					if (success === true) {
						// Show the body, load the main folder
						console.log("login success");
						$("#login_container").remove();
						$("#body_container").show();
						showRootFolder();
					} else {
						console.log("login failure");
						$("#loginBox").append("LOGIN FAILED");
					}
				});
			});
		}
	};

	showRootFolder = function () {
		waveboxData.getFolder(null, null, function (success, data) {
			if (success) {
				browseViewController.clearViews();
				publicMembers.showFolder(null, data);
			}
		});
	};

	// initialize templates
	artistsTemplate = new EJS({url: 'templates/artistsTable.ejs'});
	albumsTemplate = new EJS({url: 'templates/albumsTable.ejs'});
	songsTemplate = new EJS({url: 'templates/songsTable.ejs'});
	playQueueTemplate = new EJS({url: 'templates/playQueue.ejs'});
	playQueueCellTemplate = new EJS({url: 'templates/playQueueCell.ejs'});
	folderTemplate = new EJS({url: 'templates/folder.ejs'});
	loginTemplate = new EJS({url: 'templates/loginBox.ejs'});


	renderPlaylist = function (e, playlist) {

		$("#nowPlaying_songList").html(playQueueTemplate.render({"playlist": playlist, "playQueueCellTemplate": playQueueCellTemplate}));
		$.publish("player/playlistContentsFinishedRendering");
		$("#playQueueList").sortable({
			start: function (event, ui) {
				ui.item.startIndex = ui.item.index();
			},
			update: function (event, ui) {
				if (ui.item.hasClass("songRow")) {
					// We're adding an item to the play queue
					waveboxPlayer.addToPlaylist(JSON.parse(decodeURIComponent(ui.item.data("mediaitem"))), ui.item.index());

				} else if (ui.item.hasClass("folderRow")) {
					// We're adding a folder. Load the contents
					waveboxData.getFolder(ui.item.data("folder").folderId, true, function (success, data) {
						if (success) {
							// Got the contents, add them now
							waveboxPlayer.addArrayToPlaylist(data.songs, ui.item.index());
						}
					});

				} else {
					// We're moving an item inside the play queue
					waveboxPlayer.moveItem(ui.item.startIndex, ui.item.index());
				}
			}
		});
	};

	// subscribe to appropriate notifications
	$.subscribe("player/newSong", function (e, song) {
		updateNowPlaying(e, song);
		//publicMembers.updateElapsedTime(e, 0, song.duration);
	});
	$.subscribe("ui/artistWasClicked", publicMembers.showArtistAlbums);
	$.subscribe("ui/albumWasClicked", publicMembers.showAlbumSongs);
	$.subscribe("player/playlistContentsChanged", renderPlaylist);
	$.subscribe("ui/folderWasClicked", publicMembers.showFolder);

	$(function () {
		$("#logOut").click(publicMembers.logOut);
	});


	return publicMembers;
}());


waveboxPlayer = (function () {

	var playing, shuffleEnabled, shuffledPlaylist, normalOrderPlaylist, repeatMode, elapsedTime, playlistComingUp, titleTempStore, saveToLocalStorage, setPlayerSong, loadFromLocalStorage, publicMembers;

	playing = false;
	shuffleEnabled = false;
	shuffledPlaylist = [];
	normalOrderPlaylist = [];
	repeatMode = "off";
	elapsedTime = 0;
	playlistComingUp = [];  // The "now playing" playlist

	saveToLocalStorage = function () {
		// Save to local storage if available
		if (Storage !== undefined) {
			localStorage.playlistComingUp = JSON.stringify(playlistComingUp);
			//console.log("setting playlistComingUp: " + localStorage.playlistComingUp);
		}
	};

	setPlayerSong = function (song, shouldPlay) {
		var streamString = waveboxData.getSongStreamUrl(song.itemId);
		$("#jquery_jplayer_1").jPlayer("setMedia", {"mp3": streamString});

		if (shouldPlay !== false) {
			$("#jquery_jplayer_1").jPlayer("play");
		}

		saveToLocalStorage();

		$.publish("player/newSong", [ song ]);
	};

	loadFromLocalStorage = function () {
		// Load from local storage if available
		if (Storage !== undefined) {
			if (localStorage.playlistComingUp !== undefined && localStorage.playlistComingUp !== null) {
				playlistComingUp = JSON.parse(localStorage.playlistComingUp);
				//console.log("playlistComingUp: " + playlistComingUp);
			}
		}
	};

	publicMembers = {
		loadFromLocalStorage: function () {
			loadFromLocalStorage();
			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		setNowPlayingIndex: function (index) {
			if (index !== playlistComingUp.NowPlayingIndex && index >= 0 && index < playlistComingUp.length) {
				playlistComingUp.NowPlayingIndex = index;
				setPlayerSong(playlistComingUp[playlistComingUp.NowPlayingIndex], true);
			}
		},
		moveItem: function (startIndex, endIndex) {
			// Sanity check
			if (startIndex !== undefined && endIndex !== undefined &&
					startIndex >= 0 && startIndex < playlistComingUp.length &&
					endIndex >= 0 && endIndex < playlistComingUp.length &&
					startIndex !== endIndex) {

				var item = playlistComingUp[startIndex];

				// Remove the original
				playlistComingUp.splice(startIndex, 1);

				// Calculate the real endIndex
				if (startIndex < endIndex) {
					endIndex++;
				}

				// Move it or lose it
				playlistComingUp.splice(endIndex, 0, item);

				saveToLocalStorage();

				$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
			}
		},
		addToPlaylist: function (item, index) {
			var insertIndex;

			if (item === undefined) {
				return;
			} else if (index !== undefined) {
				insertIndex = index;
			} else {
				insertIndex = playlistComingUp.length;
			}

			if (insertIndex < playlistComingUp.length) {
				// we need shift everything to the right to make room for the new item
				playlistComingUp.splice(insertIndex, 0, item);
			} else {
				playlistComingUp.push(item);
			}

			if (shuffleEnabled === true) {
				normalOrderPlaylist.push(item);
			}

			// If the playlist was empty before we started, we need to set update Now Playing and set
			// the media for the player so that it will play if the user presses the play button.
			if (playlistComingUp.length === 1) {
				playlistComingUp.NowPlayingIndex = 0;
				setPlayerSong(item, false);
			}

			saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		addArrayToPlaylist: function (itemsArray, index) {
			var insertIndex, a, b;

			if (!$.isArray(itemsArray)) {
				console.log("itemsArray: " + JSON.stringify(itemsArray));
				return;
			} else if (index !== undefined) {
				insertIndex = index;
			} else {
				insertIndex = playlistComingUp.length;
			}

			if (insertIndex < playlistComingUp.length) {
				// we need shift everything to the right to make room for the new item
				//playlistComingUp.splice(insertIndex, 0, item);
				Array.prototype.splice.apply(playlistComingUp, [insertIndex, 0].concat(itemsArray));
			} else {
				a = playlistComingUp.slice(0);
				b = itemsArray.slice(0);
				//a.splice.apply(b, [b.length, 9e9]);

				playlistComingUp = a.concat(b);
				//playlistComingUp.push.apply(itemsArray);
			}

			if (shuffleEnabled === true) {
				normalOrderPlaylist.push(playlistComingUp, itemsArray);
			}

			// If the playlist was empty before we started, we need to set update Now Playing and set
			// the media for the player so that it will play if the user presses the play button.
			if (playlistComingUp.length === 1) {
				playlistComingUp.NowPlayingIndex = 0;
				setPlayerSong(itemsArray[0], false);
			}

			saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		removeFromPlaylist: function (index) {
			if (index === undefined) {
				return;
			}

			if (playlistComingUp[index] !== undefined) {
				playlistComingUp.splice(index, 1);
			}

			saveToLocalStorage();

			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		clearPlaylist: function () {
			playlistComingUp = [];
			normalOrderPlaylist = [];
			shuffledPlaylist = [];
			$("#nowPlaying_songList").empty();
			saveToLocalStorage();
			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		next: function (e) {
			//console.log("next - NowPlayingIndex = " + playlistComingUp.NowPlayingIndex);
			if (repeatMode === "repeatOne" && e.type !== "click") {
				$("#jquery_jplayer_1").jPlayer("play", 0);
				return;
			} else if (playlistComingUp.length > playlistComingUp.NowPlayingIndex + 1) {
				playlistComingUp.NowPlayingIndex++;
				setPlayerSong(playlistComingUp[playlistComingUp.NowPlayingIndex], true);
			} else if (repeatMode === "repeatAll" && playlistComingUp.length <= playlistComingUp.NowPlayingIndex + 1) {
				playlistComingUp.NowPlayingIndex = 0;
				setPlayerSong(playlistComingUp[playlistComingUp.NowPlayingIndex], true);
			} else {
				document.title = "WaveBox";
				$("#jquery_jplayer_1").jPlayer("stop", 0);
				playing = undefined;
			}
		},
		previous: function () {
			//console.log("previous");
			if (elapsedTime > 2 || playlistComingUp.NowPlayingIndex === 0) {
				$("#jquery_jplayer_1").jPlayer("play", 0);
			} else {
				playlistComingUp.NowPlayingIndex--;
				setPlayerSong(playlistComingUp[playlistComingUp.NowPlayingIndex], true);
			}
		},
		playPause: function () {
			//console.log("playPause");

			// ask the user if we're allowed to send notifications
			var permission = window.webkitNotifications.checkPermission();
			console.log("permission" + permission);
			if (permission !== 0) {
				window.webkitNotifications.requestPermission(function () {
					console.log("Notification permission granted");
				});
			}

			if (playing) {
				$("#jquery_jplayer_1").jPlayer("pause");
				titleTempStore = document.title;
				document.title = "WaveBox :: Paused";
			} else {
				if (playing === false && playing !== undefined) {
					document.title = titleTempStore;
					$("#jquery_jplayer_1").jPlayer("play");
				} else {
					$("#jquery_jplayer_1").jPlayer("play", 0);
					//$.publish("player/newSong", [ playlistComingUp[playlistComingUp.NowPlayingIndex] ]);
				}
			}
		},
		shuffle: function () {
			if (shuffleEnabled === true) {
				// informative things
				//console.log("shuffle off");
				shuffleEnabled = false;

				// adjust the now playing index
				var currentSong = playlistComingUp[playlistComingUp.NowPlayingIndex];
				normalOrderPlaylist.NowPlayingIndex = currentSong.preShuffleIndex === undefined ? playlistComingUp.NowPlayingIndex : currentSong.preShuffleIndex;

				// swap the normal order playlist back in
				playlistComingUp = normalOrderPlaylist;

				// update the shuffle button
				$(".playerButtonShuffle").html("Shuffle(Off)");
			} else {
				// informative things
				//console.log("shuffle on");
				shuffleEnabled = true;

				// copy the normal order playlist and its now playing index, then shuffle it
				shuffledPlaylist = playlistComingUp.slice();
				shuffledPlaylist.NowPlayingIndex = playlistComingUp.NowPlayingIndex;
				shuffledPlaylist.shuffle();

				// create a reference to the normal order playlist
				normalOrderPlaylist = playlistComingUp;

				// swap the two out
				playlistComingUp = shuffledPlaylist;

				// update the shuffle button
				$(".playerButtonShuffle").html("Shuffle(On)");
			}
			$.publish("player/playlistContentsChanged", [ playlistComingUp ]);
		},
		repeat: function () {
			if (repeatMode === "off") {
				repeatMode = "repeatOne";
				$(".playerButtonRepeat").html("Repeat(1)");
			} else if (repeatMode === "repeatOne") {
				repeatMode = "repeatAll";
				$(".playerButtonRepeat").html("Repeat(All)");
			} else {
				$(".playerButtonRepeat").html("Repeat(Off)");
				repeatMode = "off";
			}
			//console.log("repeatMode: " + repeatMode);
		},
		isPlaying: function (set) {
			if (set === true || set === false) {
				playing = set;
			}

			return playing;
		},
		currentSong: function () {
			return playlistComingUp[playlistComingUp.NowPlayingIndex];
		},
		currentIndex: function () {
			return playlistComingUp.NowPlayingIndex;
		},
		playlistCount: function () {
			return playlistComingUp.length;
		}
	};

	// subscribe to needed events
	$.subscribe("player/songEnded", publicMembers.next);

	// register the click handlers when the document is ready
	$(function () {
		$(".playerButtonShuffle").click(publicMembers.shuffle);
		$(".playerButtonRepeat").click(publicMembers.repeat);
		$(".playerButtonNext").click(publicMembers.next);
		$(".playerButtonPrevious").click(publicMembers.previous);
		$(".playerButtonPlayPause").click(publicMembers.playPause);
		$("#clearPlaylist").click(publicMembers.clearPlaylist);

		$("#jquery_jplayer_1").jPlayer({
			ready: function () {
			},
			ended: function () {
				var song = publicMembers.currentSong();
				$.publish("player/songEnded", [ song ]);
			},
			play: function () {
				//console.log("playing true");
				publicMembers.isPlaying(true);
			},
			pause: function () {
				//console.log("playing false");
				publicMembers.isPlaying(false);
			},
			stop: function () {
				//console.log("stop called.");
			},
			progress: function (e) {
				//console.log("status: " + JSON.stringify(e.jPlayer.status));
				var seekPercent = e.jPlayer.status.seekPercent / 100; // Turn it into a percent
				$.publish("player/downloadUpdate", [ seekPercent ]);
			},
			timeupdate: function (e) {
				//console.log("status: " + JSON.stringify(e.jPlayer.status));
				$.publish("player/timeUpdate", [ e.jPlayer.status.currentTime, e.jPlayer.status.duration ]);
			},
			volumechange: function (e) {
				$.publish("player/volumeChange", [ e.jPlayer.options.volume, e.jPlayer.options.muted ]);
			},
			swfPath: "/swf/",
			supplied: "mp3",
			solution: "flash, html"
		});
	});

	return publicMembers;
}());

waveboxPlayerProgress = (function () {

	var lastDownloadProgress, lastPlaybackProgress, formattedTimeWithSeconds, updateUiTimeElapsed;

	formattedTimeWithSeconds = function (seconds) {
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
	};

	updateUiTimeElapsed = function (elapsedSeconds, durationSeconds) {

		var formattedElapsed, currentSong, containerWidth, proposedWidth;
		if (elapsedSeconds !== undefined) {

			// update time marker
			formattedElapsed = formattedTimeWithSeconds(elapsedSeconds);
			if (formattedElapsed !== $("#player_time_elapsed").text()) {
				$("#player_time_elapsed").text(formattedElapsed);
				// console.log("elapsed updated: " + formattedElapsed);
			}

			// update progress bar
			currentSong = waveboxPlayer.currentSong();
			containerWidth = $("#player_progress_bar").width();
			proposedWidth = Math.round((elapsedSeconds / currentSong.duration) * containerWidth);
			if (elapsedSeconds !== lastPlaybackProgress) {
				$("#player_progress_bar_playback").css("width", proposedWidth <= containerWidth ? proposedWidth : containerWidth);
				lastPlaybackProgress = elapsedSeconds;
				//console.log("playback bar width updated: " + Math.round((elapsedSeconds / currentSong.duration) * containerWidth));
			}
		}
	};

	$.subscribe("player/downloadUpdate", function (e, downloadPercent) {
		console.log("download percent " + downloadPercent);
		var containerWidth = $("#player_progress_bar").width();
		$("#player_progress_bar_buffer").width(Math.round(downloadPercent * containerWidth));
	});

	$.subscribe("player/timeUpdate", function (e, elapsed, duration) {
		updateUiTimeElapsed(elapsed, duration);
	});

	$.subscribe("player/newSong", function (e, theNewSong) {
		$("#player_time_duration").text(formattedTimeWithSeconds(theNewSong.duration));
	});

	// register the click handlers when the document is ready
	$(function () {
		var seek, isMouseDown;

		seek = $.throttle(100, function (percent) {
			// Handle seeking
			//var internalOffset = event.pageX - this.offsetLeft;
			//var percent = (internalOffset / $(this).width()) * 100;
			console.log("setting playhead to " + percent);
			$("#jquery_jplayer_1").jPlayer("playHead", percent);
		});

		isMouseDown = false;
		$("#player_progress_bar").bind("mousedown mousemove mouseout mouseup", function (event) {

			var internalOffset, percent;

			if (event.type === "mousedown") {
				isMouseDown = true;
			}

			if (event.type === "mouseup") {
				isMouseDown = false;
			}

			if (isMouseDown === true) {
				internalOffset = event.pageX - this.offsetLeft;
				percent = (internalOffset / $(this).width()) * 100;
				seek(percent);
			}
		});
	});

}());

waveboxVolumeController = (function () {

	// Initialize the slider when the DOM is ready
	$(function () {
		var slider = $('#slider'),
			tooltip = $('.tooltip');

		tooltip.hide();
		slider.slider({
			range: "min",
			min: 1,
			value: 80,

			start: function (event, ui) {
				tooltip.fadeIn('fast');
			},

			slide: function (event, ui) {

				var value = slider.slider('value'),
					volume = $('.volume');

				$("#jquery_jplayer_1").jPlayer("volume", value / 100);

				//console.log(value / 100);
				tooltip.css('left', value).text(ui.value);

				if (value <= 5) {
					volume.css('background-position', '0 0');
				} else if (value <= 25) {
					volume.css('background-position', '0 -25px');
				} else if (value <= 75) {
					volume.css('background-position', '0 -50px');
				} else {
					volume.css('background-position', '0 -75px');
				}
			},

			stop: function (event, ui) {
				tooltip.fadeOut('fast');
				//console.log("volume slider stopped on " + slider.slider('value'));
			}
		});
	});
}());

waveboxLastfm = (function () {
	var publicMembers = { };

	$.subscribe("player/songEnded", function (e, songThatEnded) {
		waveboxData.lfmScrobbleTrack(songThatEnded, Math.round((new Date()).getTime() / 1000));
	});

	$.subscribe("player/newSong", function (e, theNewSong) {
		waveboxData.lfmUpdateNowPlaying(theNewSong.itemId);
		//console.log("Track \"" + theNewSong.songName + "\" is now playing on last.fm")
	});

	return publicMembers;
}());

waveboxNotifications = (function () {

	$.subscribe("player/newSong", function (e, theNewSong) {

		var artUrl, n;
		if (window.webkitNotifications.checkPermission() === 0) {
			artUrl = waveboxData.getSongArtUrl(theNewSong, 60);
			n = window.webkitNotifications.createNotification(artUrl, theNewSong.artistName + " - " + theNewSong.songName, 'This song is now playing on WaveBox.');
			n.show();
		}
	});
}());


/*
	Init
*/
$(function () {

	// These are for testing
	//localStorage.clear();
	//localStorage.setItem("waveBoxSessionKey", "blah");

	// First see if we are already authenticated, if so just show the page, otherwise make the user log in
	waveboxData.clientIsAuthenticated(function (success, error) {
		if (success === true) {
			waveboxPlayer.loadFromLocalStorage();
			controller.showFolder();
		} else {
			controller.showLogin();
		}
	});
});
