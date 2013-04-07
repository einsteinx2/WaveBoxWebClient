/// <reference path="./Song.ts"/>

class PlayQueueList extends Backbone.Collection 
{
    // Reference to this collection's model.
    model = Song;
}