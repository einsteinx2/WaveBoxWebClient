/// <reference path="./SidebarMenuView.ts"/>
/// <reference path="./AlbumListView.ts"/>
/// <reference path="../DataModel/AlbumList.ts"/>

class ApplicationView extends Backbone.View 
{
	sidebarMenu: SidebarMenuView;
	albumList: AlbumListView;

	constructor ()
	{
        super();

        // Create the menu
        this.sidebarMenu = new SidebarMenuView();
        this.sidebarMenu.render();

        // Create the album list with some test data
        this.albumList = new AlbumListView();
        var albums = new Array(30);
        for (var i = 1; i < 31; i++)
        {
        	albums[i-1] = {
        		artistId: i, 
        		artistName: "Test Artist " + i,
        		albumId: i,
        		albumName: "Test Album " + i,
        		releaseYear: 2013,
        		artId: i,
        		artUrl: "art/" + i + ".jpg",
        		numberOfSongs: i
        	};
        }
        this.albumList.albumList = new AlbumList(albums);

        $("#contentScroller").append(this.albumList.render().el);
    }
}