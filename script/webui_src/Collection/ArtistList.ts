/// <reference path="../Model/Album.ts"/>

module Collection
{
    export class ArtistList extends Backbone.Collection 
    {
        // Reference to this collection's model.
        model = Model.Artist;
    }
}