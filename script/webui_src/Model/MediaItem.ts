/// <reference path="./WaveBoxModel.ts"/>
module Model
{
    export class MediaItem extends WaveBoxModel
    {
        itemTypeId: number;
        itemId: number;
        folderId: string;
        fileType: string;
        duration: number;
        bitrate: number;
        fileSize: number;
        lastModified: number;
        fileName: string;
        artId: number;

        formatDuration() : string
        {
            var minutes = Math.floor(this.duration / 60);
            var seconds = Math.floor(this.duration % 60);

            return minutes + ":" + seconds;
        }
    }
}