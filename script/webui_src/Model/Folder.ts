/// <reference path="./WaveBoxModel.ts"/>
module Model
{
    export class Folder extends WaveBoxModel
    {
        itemTypeId: number;
        folderId: number;
        folderName: string;
        parentFolderId: number;
        mediaFolderId: number;
        folderPath: string;
        artId: number;
    }
}