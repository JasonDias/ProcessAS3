package com.jasondias.process.processor
{
	import com.jasondias.process.IProcess;

	import flash.events.IEventDispatcher;

	public interface IProcessor extends IEventDispatcher
	{
		function getRunningProcesses():Array;

		function getQueuedProcesses():Array;

		function addProcess(myProcess:IProcess):void;

		function getProcessIndex(myProcess:IProcess):Number;

		function removeProcess(myProcess:IProcess):void;

		function clearProcesses():void;

		function beginProcessing():void;

		function isComplete():Boolean;

		function reset():void;
	}
}
