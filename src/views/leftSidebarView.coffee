module.exports = Backbone.View.extend
    el: "#left"
    initialize: ->
        

    events: ->
        "click .addPlaylist": @addPlaylist
        "click .editPlaylists": @editPlaylists

    render: ->
        this

    addPlaylist: ->
        alert "addPlaylist"

    editPlaylists: ->
        alert "editPlaylists"
