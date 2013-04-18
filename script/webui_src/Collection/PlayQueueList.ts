/// <reference path="./WaveBoxCollection.ts"/>
/// <reference path="../Model/Song.ts"/>

module Collection
{
	export class PlayQueueList extends WaveBoxCollection 
	{
	    // Reference to this collection's model.
	    model = Model.Song;
	}
}