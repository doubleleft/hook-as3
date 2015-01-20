package com.doubleleft.hook
{
	import com.adobe.serialization.json.*;
	import flash.events.*;
	import flash.net.*;

	public class Request extends EventDispatcher
	{
		protected var request : URLRequest;
		protected var loader : URLLoader;

		public function Request(method : String, url : String , data : Object = null, headers : Array = null)
		{
			var variables : URLVariables = new URLVariables();
			variables.data = (new JSONEncoder(data).getString());

			this.request = new URLRequest();
			this.request.data = variables;
			this.request.url = url;

			// request headers
			for (var i : uint = 0; i<headers.length; i++)
			{
				this.request.requestHeaders.push(headers[i]);
			}

			this.loader = new URLLoader();
			this.loader.load(this.request);
			this.loader.addEventListener(Event.COMPLETE, this.handleComplete);
		}

		protected function handleComplete(evt : HTTPStatusEvent) : void
		{
			var data : Object = (new JSONDecoder(this.loader.data, true).getValue());

			if (evt.status < 400) {
				this.dispatchEvent(new ResponseEvent(ResponseEvent.SUCCESS, data));

			} else if (evt.status >= 400) {
				this.dispatchEvent(new ResponseEvent(ResponseEvent.ERROR, data));
			}

			this.dispatchEvent(new ResponseEvent(ResponseEvent.COMPLETE, data));
		}

	}

}
