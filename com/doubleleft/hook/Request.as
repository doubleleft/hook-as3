package com.doubleleft.hook
{
	import flash.net.*;

	public class Request extends EventDispatcher
	{
		protected var request : URLRequest;
		protected var loader : URLLoader;

		public function Request(method : URLRequestMethod, url : String , data : Object = null, headers : Object = null)
		{
			var variables : URLVariables = new URLVariables();
			variables.data = JSON.encode(data);

			this.request = new URLRequest();
			this.request.requestHeaders = headers;
			this.request.data = variables;
			this.request.url = url;

			this.loader = new URLLoader();
			this.loader.load(this.request);
			this.loader.addEventListener(Event.COMPLETE, this.handleComplete);
		}

		protected function handleComplete(evt : HTTPStatusEvent) : void
		{
			var data : Object = JSON.parse(this.loader.data);

			if (evt.status < 400) {
				this.dispatchEvent(new ResponseEvent(ResponseEvent.SUCCESS, data));

			} else if (evt.status >= 400) {
				this.dispatchEvent(new ResponseEvent(ResponseEvent.ERROR, data));
			}

			this.dispatchEvent(new ResponseEvent(ResponseEvent.COMPLETE, data));
		}

	}

}
