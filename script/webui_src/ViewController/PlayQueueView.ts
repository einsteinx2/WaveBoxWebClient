/// <reference path="../Model/Song.ts"/>
/// <reference path="../Collection/PlayQueueList.ts"/>
/// <reference path="./PlayQueueItemView.ts"/>

module ViewController
{
    // This represents the entire sidebar menu
    export class PlayQueueView extends Backbone.View 
    {
        playQueueList: Collection.PlayQueueList;

        constructor()
        {        
            super();

            // Bind to existing element
            this.setElement($("#QueueScroller"), true);
        }

        render()
        {
            // Clear the view
            this.$el.empty();

            // Add the items to the DOM
            this.playQueueList.each((item : Model.Song) => {

                var itemView = new PlayQueueItemView({model: item});
                this.$el.append(itemView.render().el);
            });

            return this;
        }
    }
}