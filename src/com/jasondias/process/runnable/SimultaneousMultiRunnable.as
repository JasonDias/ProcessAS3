package com.jasondias.process.runnable
{
	import com.jasondias.utils.ArrayUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class SimultaneousMultiRunnable extends EventDispatcher implements IMultiRunnable
	{
		private var ourRunnable:Array;
		private var ourCurrentlyRunningRunnable:Number;

		function SimultaneousMultiRunnable()
		{
			ourRunnable = [];
		}

		public function addRunnable(myRunnable:IRunnable):void
		{
			myRunnable.addEventListener(Event.COMPLETE, runnableComplete);
			ourRunnable.push(myRunnable);
		}

		public function removeRunnable(myRunnable:IRunnable):void
		{
			myRunnable.removeEventListener(Event.COMPLETE, runnableComplete);
			ArrayUtil.removeValueFromArray(ourRunnable, myRunnable);
		}

		public function start(myData:Object):void
		{
			ourCurrentlyRunningRunnable = ourRunnable.length;
			for (var i:int = 0; i < ourRunnable.length; i++)
			{
				IRunnable(ourRunnable[i]).start(myData);
			}
		}

		public function removeAllRunnable():void
		{
			for (var i:int = 0; i < ourRunnable.length; i++)
			{
				removeRunnable(ourRunnable[i]);
			}
		}

		private function runnableComplete(event:Event):void
		{
			ourCurrentlyRunningRunnable--;
			if (ourCurrentlyRunningRunnable <= 0)
				dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
