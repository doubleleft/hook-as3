package com.doubleleft.hook
{
	import flash.events.*;
	import flash.net.SharedObject;

	import com.adobe.serialization.json.*;

	public class Auth extends EventDispatcher
	{
		protected var client : Client;
		public var currentUser : Object = null;

		protected var localStorage : SharedObject;

		public static var ON_LOGIN : String = "hookLogin";
		public static var ON_LOGOUT : String = "hookLogout";

		public function Auth(client : Client)
		{
			this.client = client;

			this.localStorage = SharedObject.getLocal("hook" + this.client.app_id);

			var now : Date = new Date(),
					tokenExpiration : Date = new Date(this.localStorage.data.tokenExpiration),
					currentUser : String = this.localStorage.data.currentUser;

			// Fill current user only when it isn't expired yet.
			if (currentUser != null && now.getTime() < tokenExpiration.getTime()) {
				// localStorage only supports recording strings, so we need to parse it
				this.currentUser = (new JSONDecoder(currentUser, true).getValue());
			}
		}

		public function getToken() : String
		{
			return this.localStorage.data.authToken;
		}

		public function register(data : Object) : Request
		{
			var req : Request = this.client.post("auth/email", data);
			req.addEventListener(ResponseEvent.SUCCESS, this.onLoginOrRegister);
			return req;
		}

		public function login(data : Object) : Request
		{
			var req : Request = this.client.post("auth/email/login", data);
			req.addEventListener(ResponseEvent.SUCCESS, this.onLoginOrRegister);
			return req;
		}

		public function update(data : Object) : Request
		{
			if (this.currentUser == null) {
				throw new Error("not_logged_in");
			}

			var req : Request = this.client.collection("auth").update(this.currentUser._id, data);
			req.addEventListener(ResponseEvent.SUCCESS, this.onAuthUpdate);

			return req;
		}

		public function forgotPassword(data : Object) : Request
		{
			return this.client.post("auth/email/forgotPassword", data);
		}

		public function resetPassword(data : Object) : Request
		{
			if (data is String) {
				data = { password: data };
			}

			if (data.token == undefined) {
				/* data.token = window.location.href.match(/[\?|&]token=([a-z0-9]+)/); */
				/* data.token = (data.token && data.token[1]); */
			}

			if (!(data.token is String)) { throw new Error("forgot password token required. Remember to use 'auth.forgotPassword' before 'auth.resetPassword'."); }
			if (!(data.password is String)) { throw new Error("new password required."); }

			return this.client.post("auth/email/resetPassword", data);
		}

		public function logout() : Auth
		{
			this.setCurrentUser(null);
			return this;
		}

		public function setCurrentUser(data : Object = null) : Auth
		{
			if (!data) {
				// trigger logout event
				this.dispatchEvent(new Event(ON_LOGOUT));
				this.currentUser = data;

				this.localStorage.setProperty("authToken", null);
				this.localStorage.setProperty("currentUser", null)
			} else {
				this.localStorage.setProperty("currentUser", (new JSONEncoder(data).getString()));

				// trigger login event
				this.currentUser = data;
				this.dispatchEvent(new Event(ON_LOGIN));
			}

			return this;
		}

		protected function registerToken(data : Object) : void
		{
			if (data.token) {
				// register authentication token on localStorage
				this.localStorage.setProperty("authToken", data.token.token);
				this.localStorage.setProperty("tokenExpiration", data.token.expire_at);
				delete data.token;

				// Store curent user
				this.setCurrentUser(data);
			}
		}

		protected function onAuthUpdate(evt : ResponseEvent) : void {
			this.setCurrentUser(evt.data);
			evt.target.removeEventListener(ResponseEvent.SUCCESS, this.onAuthUpdate);
		}

		protected function onLoginOrRegister(evt : ResponseEvent) : void {
			this.registerToken(evt.data);
			evt.target.removeEventListener(ResponseEvent.SUCCESS, this.onLoginOrRegister);
		}

	}

}
