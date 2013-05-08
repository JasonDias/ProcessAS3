package com.jasondias.process.event
{
	import flash.events.Event;

	public class ProcessEvent extends Event
	{
		public static var PROGRESS:String = "ProcessEvent.PROGRESS";
		public static var COMPLETE:String = "ProcessEvent.COMPLETE";
		public static var START:String = "ProcessEvent.START";
		public static var ERROR:String = "ProcessEvent.ERROR";
		public var error:Error;

		function ProcessEvent(myType:String)
		{
			super(myType);
		}
	}
}
