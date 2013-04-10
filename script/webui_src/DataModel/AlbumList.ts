/// <reference path="./Album.ts"/>

module DataModel
{
	export class AlbumList extends Backbone.Collection 
	{
	    // Reference to this collection's model.
	    model = DataModel.Album;
	}
}