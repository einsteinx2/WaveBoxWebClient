/// <reference path="../Model/Album.ts"/>

module Collection
{
	export class AlbumList extends Backbone.Collection 
	{
	    // Reference to this collection's model.
	    model = Model.Album;
	}
}