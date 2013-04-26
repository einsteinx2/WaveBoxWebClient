var Clickbuster = (function() {

                function Clickbuster() {}

                clickbusterDistance = 25;
                clickbusterTimeout = 2500;
                clickDistance = 10;

                Clickbuster.coordinates = [];

                Clickbuster.preventGhostClick = function(x, y) {
                  Clickbuster.coordinates.push(x, y);
                  return window.setTimeout(Clickbuster.pop, clickbusterTimeout);
                };

                Clickbuster.pop = function() {
                  return Clickbuster.coordinates.splice(0, 2);
                };

                Clickbuster.onClick = function(event) {
                  var coordinates, dx, dy, i, x, y;
                  coordinates = Clickbuster.coordinates;
                  i = 0;
                  if (event.clientX == null) {
                    return true;
                  }
                  window.ev = event;
                  while (i < coordinates.length) {
                    x = coordinates[i];
                    y = coordinates[i + 1];
                    dx = Math.abs(event.clientX - x);
                    dy = Math.abs(event.clientY - y);
                    i += 2;
                    if (dx < clickbusterDistance && dy < clickbusterDistance) {
                      return false;
                    }
                  }
                  return true;
                };

                return Clickbuster;

              })();