$.prototype.wbTranslate = function(x, duration, easing, callback) {

	// check the input
	var easingVal;
	if (typeof easing === "undefined" || easing == null) {
		easingVal = "ease";
	} else {
		easingVal = easing;
	}

	// find our current location
	var currentX, currentStringX = this.css("left");
	if (currentStringX === "0px" || currentStringX === "0" || currentStringX === "auto") {
		currentX = 0;
	} else {
		currentX = parseInt(currentStringX);
	}

	// do nothing if we aren't going to move
	if (currentX == x) {
		if (typeof callback !== "undefined") {
			callback.call(this);
		}
		return this;
	}

	// calculate the direction and offset we want to translate by
	var destDir = -1;
	if (x >= currentX) {
		destDir = 1;
	}
	var signDest = x && x / Math.abs(x);
	var signBegin = currentX && currentX / Math.abs(currentX);
	var xDiff;

	if (x == 0) {
		xDiff = -1 * currentX;
	}
	else if (signDest == signBegin) {
		xDiff = destDir * Math.abs((Math.abs(x) - Math.abs(currentX)));
	} else {
		xDiff = destDir * Math.abs((Math.abs(x) + Math.abs(currentX)));
	}

	// perform the translation
	this.css({
		"-webkit-transform": "translate3d(" + xDiff + "px, 0, 0)",
		"-webkit-transform-style": "preserve-3d",
		"-webkit-transition": "-webkit-transform " + duration + "ms " + easingVal
	});

	// set the timeout to happen after the specified duration of time
	var that = this;
	setTimeout(function () {
		that.css({
			"-webkit-transform": "none",
			"-webkit-transition": "0s 0s all ease",
			"-webkit-transform-style": "flat",
			"left": x + "px"
		});

		if (typeof callback !== "undefined") {
			callback.call(this);
			return this;
		}
	}, duration);
}