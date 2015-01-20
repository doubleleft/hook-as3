package com.doubleleft.hook
{

	public class System
	{
		protected var client : Client;

		public function System(client : Client)
		{
			this.client = client;
		}

		public function time(name : String) : Request
		{
			return this.client.get("system/time");
		}

	}

}




