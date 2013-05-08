package com.jasondias.process.processor
{
	import com.jasondias.process.IProcess;

	import flash.events.Event;

	public class ProcessorEvent extends Event
	{
		public static var REQUEST_PROCESS_RUN:String = "ProcessorEvent.REQUEST_PROCESS_RUN";
		public static var PROCESSING_COMPLETE:String = "ProcessorEvent.PROCESSING_COMPLETE";
		public var requestedProcessToRun:IProcess;

		function ProcessorEvent(myType:String)
		{
			super(myType);
		}
	}
}
