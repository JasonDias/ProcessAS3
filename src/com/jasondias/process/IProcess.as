package com.jasondias.process
{
	import com.jasondias.process.display.IProcessDisplayManager;

	import flash.events.IEventDispatcher;

	public interface IProcess extends IEventDispatcher
	{
		function process(myParentProcess:IProcess = null):void;

		function start(myParentProcess:IProcess = null):void;

		function reset():void;

		function getProgress():Number;

		function getProgressText():String;

		function getProcessedResult():*;

		function getProcessName():String;

		function getSubProcesses():Array;

		function clearSubProcesses():void;

		function setParentProcess(myParentProcess:IProcess):void;

		function getParentProcess():IProcess;

		function addSubProcess(myProcess:IProcess):void;

		function removeSubProcess(myProcess:IProcess):void;

		function removeSubProcessesOfType(myTypeClass:Class):void;

		function getRunningProcesses():Array;

		function getQueuedProcesses():Array;

		function getProcessDisplayManager():IProcessDisplayManager;

		function setHaltOnErrors(myHalt:Boolean):void;
	}
}
