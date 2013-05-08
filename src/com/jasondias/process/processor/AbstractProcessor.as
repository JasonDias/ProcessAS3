package com.jasondias.process.processor
{
	import com.jasondias.process.IProcess;

	import flash.events.EventDispatcher;

	public class AbstractProcessor extends EventDispatcher
	{

		protected function fireOnRequestProcessRun(myProcessToRun:IProcess):void
		{
			var myEvent:ProcessorEvent = new ProcessorEvent(ProcessorEvent.REQUEST_PROCESS_RUN);
			myEvent.requestedProcessToRun = myProcessToRun;
			dispatchEvent(myEvent);
		}

		protected function fireOnProcessingComplete():void
		{
			var myEvent:ProcessorEvent = new ProcessorEvent(ProcessorEvent.PROCESSING_COMPLETE);
			dispatchEvent(myEvent);
		}


	}
}
