module ViewController
{
    // Super class for all views
    export class WaveBoxView extends Backbone.View 
    {
        parentView: Backbone.View;

        constructor(options?) 
        {
            super(options);

            // Set the parentView from the options, so it can be added easily
            this.parentView = this.options.parentView;
            
            // Make sure all object methods have the correct "this" behavior
            _.bindAll(this);
        }

        appendToParent()
        {
            this.parentView.$el.append(this.el);
        }
    }
}