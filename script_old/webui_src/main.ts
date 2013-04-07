/// <reference path="references.ts"/>
/// <reference path="DataModel/RestClient.ts"/>
/// <reference path="DataModel/WaveboxNotifications.ts"/>
/// <reference path="LastFM/WaveboxLastfm.ts"/>
/// <reference path="ViewControllers/WaveboxFolderContextViewController.ts"/>
/// <reference path="ViewControllers/PlayQueueViewController.ts"/>
/// <reference path="ViewControllers/BrowseViewController.ts"/>
/// <reference path="ViewControllers/Controller.ts"/>
/// <reference path="AudioPlayer/WaveboxPlayer.ts"/>
/// <reference path="AudioPlayer/WaveboxPlayerProgress.ts"/>
/// <reference path="AudioPlayer/WaveboxVolumeController.ts"/>

/*
    Globals
 */
var controller, waveboxLastfm, waveboxNotifications;

/*
	Init
*/
$(function () {
	AudioPlayer.setup();
	controller = new ViewControllers.Controller();
	waveboxLastfm = new LastFM.WaveboxLastfm();
	waveboxNotifications = new DataModel.WaveboxNotifications();

	// These are for testing
	//localStorage.clear();
	//localStorage.setItem("waveBoxSessionKey", "blah");

	// First see if we are already authenticated, if so just show the page, otherwise make the user log in
	DataModel.RestClient.clientIsAuthenticated((success, error) => {
		if (success === true) 
		{
			AudioPlayer.player.loadFromLocalStorage();
			controller.showFolder();
		}
	 	else 
	 	{
			controller.showLogin();
		}
	});
});
