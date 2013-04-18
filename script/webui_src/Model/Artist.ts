/// <reference path="./WaveBoxModel.ts"/>
/// <reference path="./ApiClient.ts"/>

module Model
{
    export class Artist extends WaveBoxModel
    {
        itemTypeId: number;
        artistId: number;
        artistName: string;
        artId: number;
    }
}