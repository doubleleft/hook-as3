package com.doubleleft.hook
{

	public class Auth
	{
		protected var client : Client;

		protected static AUTH_DATA_KEY = "hook-auth-data";
		protected static AUTH_TOKEN_KEY = "hook-auth-token";
		protected static AUTH_TOKEN_EXPIRATION = "hook-auth-token-expiration";

		public function Auth(client : Client)
		{
			this.client = client;
		}

		public function getToken() : String
		{
			return null;
		}

		public function register(data : Object)
		{
		}

		public function login(data : Object)
		{
		}

		public function update(data : Object)
		{
		}

		public function forgotPassword(data : Object)
		{
		}

		public function resetPassword(data : Object)
		{
		}

		public function logout()
		{
		}

		public function setCurrentUser(data : Object)
		{
		}

		protected function registerToken(data : Object)
		{
		}

	}

}
