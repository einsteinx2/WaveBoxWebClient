/// <reference path="../references.ts"/>

module ViewControllers
{
	export class WaveboxVolumeController
	{
		// Initialize the slider
		constructor() 
		{
			var slider = $('#slider')
			var tooltip = $('.tooltip');

			tooltip.hide();
			slider.slider({
				range: "min",
				min: 1,
				value: 80,

				start: (event, ui) => {
					tooltip.fadeIn('fast');
				},

				slide: (event, ui) => {

					var value = <number>slider.slider('value');
					var volume = $('.volume');

					$("#jquery_jplayer_1").jPlayer("volume", value / 100);

					//console.log(value / 100);
					tooltip.css('left', value).text(ui.value);

					if (value <= 5) {
						volume.css('background-position', '0 0');
					} else if (value <= 25) {
						volume.css('background-position', '0 -25px');
					} else if (value <= 75) {
						volume.css('background-position', '0 -50px');
					} else {
						volume.css('background-position', '0 -75px');
					}
				},

				stop: (event, ui) => {
					tooltip.fadeOut('fast');
					//console.log("volume slider stopped on " + slider.slider('value'));
				}
			});
		}
	}
}