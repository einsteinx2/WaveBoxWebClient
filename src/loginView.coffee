class LoginView extends Backbone.View
	el: "#login"
	template: _.template($("#template-login").html())

	events:
		"keydown": "keydown"
		"click #login-submit": "login"

	initialize: (options) ->
		if options.success?
			@success = options.success
		if options.error?
			@error = options.error


		console.log "Login initialized"

	render: ->
		if wavebox.apiClient.SESSION_ID?
			@$el.append("<div class='login-checking'>Checking session...</div>")
			wavebox.apiClient.clientIsAuthenticated (authenticated) =>
				if authenticated
					@remove()
					@success()
				else
					@renderLogin()

		else
			@renderLogin()

		
	renderLogin: ->
		@$el.empty().append(@template())
		@$el.show()
		@$el.find("#login-username").focus()

	keydown: (e) ->
		if e.keyCode is 13 then @login()
		return yes
	login: ->
		l = Ladda.create(document.querySelector('.login-form-button'))
		l.start()

		username = $("#login-username").val()
		password = $("#login-password").val()

		wavebox.apiClient.authenticate username, password, (success, error) =>
			if success
				@remove()
				@success()
			else
				@error error
				l.stop()
				@$el.append("nope nope nope")

module.exports = LoginView
