/// <reference path="MediaItem.ts"/>

class Song extends MediaItem
{
    artistId: number;
    artistName: string;
    albumId: number;
    albumName: string;
    songName: string;
    trackNumber: number;
    discNumber: number;
    releaseYear: number;
}