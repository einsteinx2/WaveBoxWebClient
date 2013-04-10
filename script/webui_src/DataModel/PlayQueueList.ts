/// <reference path="./Song.ts"/>

module DataModel
{
	export class PlayQueueList extends Backbone.Collection 
	{
	    // Reference to this collection's model.
	    model = Song;
	}
}