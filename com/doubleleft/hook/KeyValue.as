package com.doubleleft.hook
{

	public class KeyValue
	{
		protected var client : Client;

		public function KeyValue(client : Client)
		{
			this.client = client;
		}

		public function get(name : String)
		{
			return this.client.get("key/" + name);
		}

		public function set(name : String, value : Object)
		{
			return this.client.post("key/" + name, value);
		}

	}

}



