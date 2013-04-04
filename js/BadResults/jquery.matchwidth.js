(function($){
	$.fn.extend({
		matchWidth: function( matchTo ) {
			
			var width1 = matchTo.width();
			this.width(matchTo.width());

		}
	})
})(jQuery);
