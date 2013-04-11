/// <reference path="exports.ts"/>
/// <reference path="ViewController/ApplicationView.ts"/>

// Tino stuff
var muc;
var sbw;  
var vpw;
var vph;
var sdh;
var mbh;
//

var app;

// Load the application once the DOM is ready, using `jQuery.ready`:
$(() => {
    // Finally, we kick things off by creating the **App**.
    app = new ViewController.ApplicationView();
});