/// <reference path="./WaveBoxCollection.ts"/>
/// <reference path="../Model/Album.ts"/>

module Collection
{
	export class AlbumList extends WaveBoxCollection 
	{
	    // Reference to this collection's model.
	    model = Model.Album;
	}
}