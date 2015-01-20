package com.doubleleft.hook
{
	import flash.events.Event;

	public class ResponseEvent extends Event
	{
		public static var SUCCESS : String = "responseSuccess";
		public static var ERROR : String = "responseError";
		public static var COMPLETE : String = "responseComplete";

		public var data : Object;

		public function ResponseEvent(type : String, data : Object = null)
		{
			super(type, false, false);
			this.data = data;
		}

	}

}

