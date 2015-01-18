package com.doubleleft.hook
{
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;

	public class Client
	{

		public var app_id : String;
		public var key : String;
		public var endpoint : String;

		public var key : KeyValue;
		public var auth : Auth;
		public var system : System;

		public function Client(app_id : String, key : String, endpoint : String = "http://localhost:4665/")
		{
			this.app_id = app_id;
			this.key = key;
			this.endpoint = endpoint;

			this.key = new KeyValue(this);
			this.auth = new Auth(this);
			this.system = new System(this);
		}

		public function collection(name : String)
		{
			return new Collection(this, name);
		}

		public function post(segments : String , data : Object = null)
		{
			return this.request(URLRequestMethod.POST, segments, data);
		}

		public function put(segments : String , data : Object = null)
		{
			return this.request(URLRequestMethod.PUT, segments, data);
		}

		public function get(segments : String , data : Object = null)
		{
			return this.request(URLRequestMethod.GET, segments, data);
		}

		public function remove(segments : String , data : Object = null)
		{
			return this.request(URLRequestMethod.DELETE, segments, data);
		}

		protected function request(method : String, segments : String , data : Object = null) : Request
		{
			return new Request(method, this.endpoint + segments, data, this.getHeaders());
		}

		protected function getHeaders() : Array
		{
			var headers = new Array();
			headers.push(new URLRequestHeader("X-App-Id", this.app_id));
			headers.push(new URLRequestHeader("X-App-Key", this.key));

			var authToken : String = this.auth.getToken();
			if (authToken) {
				headers.push(new URLRequestHeader("X-Auth-Token", authToken));
			}

			return headers;
		}

	}

}

