#WaveBox HTML

WaveBox HTML is the web interface for [WaveBox](https://github.com/einsteinx2/WaveBox), an open-source media-streaming server.  It's written in CoffeeScript, using Cake for its build tool, and Browserify to bundle it for the web.  



##Building



The easiest way to build WaveBox's web UI is to first install [node.js](http://nodejs.org/), which will enable you to use npm to install the other two dependencies.  After you have installed node.js, pop open a terminal, switch to the newly cloned repo's folder, and run the following, which will automatically install the needed dependencies into a local folder:

    npm install

If installing packages globally is more your thing, you can do that instead:

    sudo npm install -g coffee-script browserify

Make sure you're in the repo's folder still and then

    cake build

Tadah! Happy tinkering!
