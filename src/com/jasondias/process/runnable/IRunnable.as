package com.jasondias.process.runnable
{
	import flash.events.IEventDispatcher;

	public interface IRunnable extends IEventDispatcher
	{
		function start(myData:Object):void;
	}
}
