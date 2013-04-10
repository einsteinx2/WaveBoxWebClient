/// <reference path="exports.ts"/>
/// <reference path="ViewController/ApplicationView.ts"/>

var application;

// Load the application once the DOM is ready, using `jQuery.ready`:
$(() => {
    // Finally, we kick things off by creating the **App**.
    application = new ViewController.ApplicationView();
});