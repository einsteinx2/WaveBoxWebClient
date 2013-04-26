/// <reference path="./ViewController/ArtistView.ts"/> 

module Router
{
	export class WaveBoxRouter extends Backbone.Router
	{
		routes = {
				// route 					func
				"artists/:artistId":		"artists",
				"folders/:folderId":		"folders"	
		};

		artists(artistId?)
		{
			var aId = artistId == undefined || artistId == null ? undefined : {"artistId": artistId};
			var view = new ViewController.ArtistView(aId);
			view.render();
		}
	}
}