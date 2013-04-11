/// <reference path="./ApiClient.ts"/>

module Model
{
    export class Artist extends Backbone.Model 
    {
        itemTypeId: number;
        artistId: number;
        artistName: string;
        artId: number;
    }
}