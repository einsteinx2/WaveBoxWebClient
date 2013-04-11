/// <reference path="../Model/Song.ts"/>

module Collection
{
	export class PlayQueueList extends Backbone.Collection 
	{
	    // Reference to this collection's model.
	    model = Model.Song;
	}
}