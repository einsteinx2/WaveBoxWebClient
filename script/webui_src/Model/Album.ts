/// <reference path="./WaveBoxModel.ts"/>

module Model
{
	export class Album extends WaveBoxModel
	{
	    itemTypeId: number;
	    artistId: number;
	    artistName: string;
	    albumId: number;
	    albumName: string;
	    releaseYear: number;
	    artId: number;
	    artUrl: string;
	    numberOfSongs: number;

	    defaults() 
        {
            return {
            	itemTypeId: 2,
            	artistId: 0,
            	artistName: "",
            	albumId: 0,
            	albumName: "",
            	releaseYear: 0,
            	artId: 0,
            	artUrl: "",
            	numberOfSongs: 0
            };
        }
	}
}