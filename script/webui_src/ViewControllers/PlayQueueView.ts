/// <reference path="../DataModel/Song.ts"/>
/// <reference path="../DataModel/PlayQueueList.ts"/>
/// <reference path="./PlayQueueItemView.ts"/>

// This represents the entire sidebar menu
class PlayQueueView extends Backbone.View 
{
    playQueueList: PlayQueueList;

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
        this.playQueueList.each((item : Song) => {
            console.log(item);

            var itemView = new PlayQueueItemView({model: item});
            this.$el.append(itemView.render().el);
        });

        return this;
    }
}