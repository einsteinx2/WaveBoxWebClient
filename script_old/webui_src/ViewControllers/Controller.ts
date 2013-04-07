/// <reference path="../references.ts"/>
/// <reference path="../DataModel/RestClient.ts"/>
/// <reference path="../AudioPlayer/WaveboxPlayer.ts"/>
/// <reference path="BrowseViewController.ts"/>
/// <reference path="WaveboxFolderContextViewController.ts"/>
/// <reference path="PlayQueueViewController.ts"/>
/// <reference path="WaveboxPlayerProgress.ts"/>
/// <reference path="WaveboxVolumeController.ts"/>

module ViewControllers
{
	export class Controller
	{
		//"use strict";

		browseViewController: BrowseViewController;
		waveboxFolderContextViewController: WaveboxFolderContextViewController;
		playQueueViewController: PlayQueueViewController;
		waveboxPlayerProgress: WaveboxPlayerProgress;
		waveboxVolumeController: WaveboxVolumeController;

		// templates
		playQueueTemplate: EJS;
		playQueueCellTemplate: EJS;
		artistsTemplate: EJS;
		albumsTemplate: EJS;
		songsTemplate: EJS;
		folderTemplate: EJS;
		loginTemplate: EJS;

		constructor()
		{
			this.browseViewController = new BrowseViewController();
			this.waveboxFolderContextViewController = new WaveboxFolderContextViewController();
			this.playQueueViewController = new PlayQueueViewController();
			this.waveboxPlayerProgress = new WaveboxPlayerProgress();
			this.waveboxVolumeController = new WaveboxVolumeController();

			// initialize templates
			this.artistsTemplate = new EJS({url: 'templates/artistsTable.ejs'});
			this.albumsTemplate = new EJS({url: 'templates/albumsTable.ejs'});
			this.songsTemplate = new EJS({url: 'templates/songsTable.ejs'});
			this.playQueueTemplate = new EJS({url: 'templates/playQueue.ejs'});
			this.playQueueCellTemplate = new EJS({url: 'templates/playQueueCell.ejs'});
			this.folderTemplate = new EJS({url: 'templates/folder.ejs'});
			this.loginTemplate = new EJS({url: 'templates/loginBox.ejs'});

			// subscribe to appropriate notifications
			$.subscribe("player/newSong", (e, song) => {
				this.updateNowPlaying(e, song);
				//publicMembers.updateElapsedTime(e, 0, song.duration);
			});
			$.subscribe("ui/artistWasClicked", (e, artistInfo) => {
				this.showArtistAlbums(e, artistInfo);
			});
			$.subscribe("ui/albumWasClicked", (e, albumInfo) => {
			    this.showAlbumSongs(e, albumInfo);
			});
			$.subscribe("player/playlistContentsChanged", (e, playlist) => {
				this.renderPlaylist(e, playlist);
			});
			$.subscribe("ui/folderWasClicked", (e, data) => {
				this.showFolder(e, data);
			});

			$("#logOut").click(this.logOut);
		}

		private updateNowPlaying(e: any, song: any): void
		{
			if (song === undefined) 
			{
				$(".nowPlaying_artContainer").fadeOut("fast");
				$(".nowPlaying_songInfoContainer").fadeOut("fast");
				return;
			}

			$(".nowPlaying_artContainer").fadeOut("fast");
			$(".nowPlaying_songInfoContainer").fadeOut("fast", () => {
				var theArt = new Image();
				theArt.onerror = () => {
					//console.log("error loading art");
					theArt.src = "/img/art_default.png";
				};

				theArt.src = DataModel.RestClient.getSongArtUrl(song, "60");
				theArt.className = "nowPlaying_art";

				$("#nowPlaying_art").empty().append(theArt);

				$("#nowPlaying_song").html(song.songName);
				$("#nowPlaying_artist").html(song.artistName);
				$("#nowPlaying_album").html(song.albumName);

				document.title = "WaveBox :: " + song.artistName + " - " + song.songName;

				$(".nowPlaying_artContainer").fadeIn("fast");
				$(".nowPlaying_songInfoContainer").fadeIn("fast");
			});
		}

		private showRootFolder(): void
		{
			DataModel.RestClient.getFolder(null, null, (success, data) => {
				if (success) {
					this.browseViewController.clearViews();
					this.showFolder(null, data);
				}
			});
		}

		public renderPlaylist(e: any, playlist: any): void
		{
			$("#nowPlaying_songList").html(this.playQueueTemplate.render({"playlist": playlist, "playQueueCellTemplate": this.playQueueCellTemplate}));
			$.publish("player/playlistContentsFinishedRendering");
			$("#playQueueList").sortable({
				start: (event, ui) => {
					ui.item.startIndex = ui.item.index();
				},
				update: (event, ui) => {
					if (ui.item.hasClass("songRow")) {
						// We're adding an item to the play queue
						AudioPlayer.player.addToPlaylist(JSON.parse(decodeURIComponent(ui.item.data("mediaitem"))), ui.item.index());

					} else if (ui.item.hasClass("folderRow")) {
						// We're adding a folder. Load the contents
						DataModel.RestClient.getFolder(ui.item.data("folder").folderId, true, (success, data) => {
							if (success) {
								// Got the contents, add them now
								AudioPlayer.player.addArrayToPlaylist(data.songs, ui.item.index());
							}
						});

					} else {
						// We're moving an item inside the play queue
						AudioPlayer.player.moveItem(ui.item.startIndex, ui.item.index());
					}
				}
			});
		}

		public logOut(): void
		{
			console.log("logout clicked");
			DataModel.RestClient.logOut();
			this.showLogin();
		}

		public showArtists(): void
		{
			var artists, html, id;
			artists = DataModel.RestClient.getArtistList();
			html = this.artistsTemplate.render({artists: artists});
			this.browseViewController.pushView(html, "tag");
			$("#artistList").delegate(".artistListItem", "click", function (e) {
				id = $(this).attr("id").substr(1);
				$.subscribe("data/getArtistInfoDone", function (e, info) {
					if (info !== undefined) {
						//console.log("artist id: " + info.artistId);
						$.publish("ui/artistWasClicked", [ info ]);
					}
					$.unsubscribe("data/getArtistInfoDone");
				});
				DataModel.RestClient.getArtistInfo(id);
			});
		}

		public showArtistAlbums(e: any, artistInfo: any): void
		{
			var albums, html, id;
			albums = artistInfo.albums;
			html = this.albumsTemplate.render({albums: albums});
			this.browseViewController.pushView(html, "tag");
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
				DataModel.RestClient.getSongList(id, "albums");
			});
		}

		public showAlbumSongs(e: any, albumInfo: any): void 
		{
			//console.log("showAlbumSongs");
			var songs, html, id;
			songs = albumInfo.songs;
			html = this.songsTemplate.render({songs: songs});
			this.browseViewController.pushView(html, "tag");
			$("#songList").delegate(".songListItem", "click", function (e) {
				id = $(this).attr("id").substr(1);
				//console.log("song id: " + id);

				$.subscribe("data/getSongInfoDone", function (e, song) {
					AudioPlayer.player.clearPlaylist();
					AudioPlayer.player.addToPlaylist(song);
					AudioPlayer.player.playPause();
					$.unsubscribe("data/getSongInfoDone");
				});
				DataModel.RestClient.getSongInfo(id);
			});

			$("#songList").delegate(".songListItemAdd", "click", function (e) {
				var id = $(this).attr("id").substr(3);
				//console.log("song id: " + id);

				$.subscribe("data/getSongInfoDone", function (e, song) {
					AudioPlayer.player.addToPlaylist(song);
					$.unsubscribe("data/getSongInfoDone");
				});
				DataModel.RestClient.getSongInfo(id);
			});
		}

		public showFolder(e: any, data: any): void
		{
			var html;
			if (e === undefined) 
			{
				this.showRootFolder();
				return;
			} 
			else if (e !== null) 
			{
				this.waveboxFolderContextViewController.updateWithFolder(data);
			}

			html = this.folderTemplate.render({mediaItems: data.songs, folders: data.folders});
			this.browseViewController.pushView(html, "folder");
			//console.log(this.browseViewController.currentViewSelector());

			$(this.browseViewController.currentViewSelector()).delegate(".folderListItemAdd", "click", function (e) {
				var id = $(this).attr("id").substr(4);
				//console.log("folder id: " + id);

				DataModel.RestClient.getFolder(id, true, (success, data) => {
					AudioPlayer.player.addArrayToPlaylist(data.songs);
				});
			});

			$(this.browseViewController.currentViewSelector()).delegate(".folderListItem", "click", function (e) {
				var id = $(this).attr("id").substr(1);
				//console.log("folder id: " + id);

				DataModel.RestClient.getFolder(id, false, (success, data) => {
					if (success) {
						$.publish("ui/folderWasClicked", [ data ]);
					}
				});
			});

			$(this.browseViewController.currentViewSelector()).delegate(".songListItem", "click", function (e) {
				// Get the data right from the dom instead of doing a network call
				AudioPlayer.player.clearPlaylist();
				AudioPlayer.player.addToPlaylist(JSON.parse(decodeURIComponent($(this).parent().parent().data("mediaitem"))));
				AudioPlayer.player.playPause();
			});

			$(this.browseViewController.currentViewSelector()).delegate(".songListItemAdd", "click", function (e) {
				// Get the data right from the dom instead of doing a network call
				AudioPlayer.player.addToPlaylist(JSON.parse(decodeURIComponent($(this).parent().parent().data("mediaitem"))));
			});

			// Handle dragging folder to the play queue
			var _this = this;
			$("tr.folderRow").draggable({
				revert: "invalid",
				helper: function () {
					return $(_this.playQueueCellTemplate.render({"itemName": data.folders[$(this).index() - 1].folderName, "index": 0}));
				},
				//helper: "clone",
				connectToSortable: "#playQueueList"
			});

			// Handle dragging song to the play queue
			$("tr.songRow").draggable({
				revert: "invalid",
				helper: function () {
					return $(_this.playQueueCellTemplate.render({"itemName": data.songs[$(this).index() - 1].songName, "index": 0}));
				},
				//helper: "clone",
				connectToSortable: "#playQueueList"
			});
		}

		public showLogin(): void
		{
			console.log("showing login");

			// Hide everything on the screen
			$("#body_container").hide();

			// Show the login box
			var html = this.loginTemplate.render();
			$("body").append(html);

			// Setup the onclick handler for the form
			$("#loginButton").click(() => {
				var username, password;

				username = $("#loginUsername").val();
				password = $("#loginPassword").val();
				DataModel.RestClient.authenticate(username, password, (success) => {
					if (success === true) {
						// Show the body, load the main folder
						console.log("login success");
						$("#login_container").remove();
						$("#body_container").show();
						this.showRootFolder();
					} else {
						console.log("login failure");
						$("#loginBox").append("LOGIN FAILED");
					}
				});
			});
		}
	}
}