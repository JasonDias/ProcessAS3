package com.jasondias.process
{
	import com.jasondias.process.display.IProcessDisplayManager;
	import com.jasondias.process.display.ProcessDisplayManager;
	import com.jasondias.process.event.ProcessEvent;
	import com.jasondias.process.processor.IProcessor;
	import com.jasondias.process.processor.PoolProcessor;
	import com.jasondias.process.processor.ProcessorEvent;
	import com.jasondias.utils.ArrayUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AbstractProcess extends EventDispatcher
	{
		public static const HALT_UNTIL_COMPLETE:String = "haltUntilComplete";
		public static const HALT_NONE:String = "haltNone";
		private static var nextUniqueID:Number = 0;
		protected var ourCompletionPercentage:Number = 0;
		protected var ourSubProcesses:Array;
		protected var ourSubProcessNameToSubProcess:Object;
		protected var ourSubProcessProcessor:IProcessor;
		protected var ourHaltOnErrors:Boolean = false;
		protected var ourUniqueID:Number;
		protected var ourParentProcess:IProcess;
		protected var ourProcessDisplayManager:IProcessDisplayManager;

		function AbstractProcess(myProcessor:IProcessor = null)
		{
			ourUniqueID = AbstractProcess.getUniqueID();
			ourSubProcesses = [];
			ourSubProcessNameToSubProcess = {};
			if (myProcessor == null)
				setProcessor(PoolProcessor.getSerialProcessor());
			else
				setProcessor(myProcessor);

			ourProcessDisplayManager = new ProcessDisplayManager(IProcess(this));
			ourProcessDisplayManager.setVisible();
		}

		static public function getUniqueID():Number
		{
			return nextUniqueID++;
		}

		public override function toString():String
		{
			return super.toString() + " (" + ourUniqueID + ") ";
		}

		public function getProcessDisplayManager():IProcessDisplayManager
		{
			return ourProcessDisplayManager;
		}

		public function clearSubProcesses():void
		{
			ourSubProcesses = [];
			ourSubProcessNameToSubProcess = {};
			ourSubProcessProcessor.clearProcesses();
		}

		public function getSubProcesses():Array
		{
			return ourSubProcesses;
		}

		public function setProcessor(myProcessor:IProcessor):void
		{
			ourSubProcessProcessor = myProcessor;
			ourSubProcessProcessor.addEventListener(ProcessorEvent.REQUEST_PROCESS_RUN, processorRequestingToRunProcess);
			ourSubProcessProcessor.addEventListener(ProcessorEvent.PROCESSING_COMPLETE, subProcessesComplete);
		}

		public function setParentProcess(myParentProcess:IProcess):void
		{
			ourParentProcess = myParentProcess;
		}

		public function getParentProcess():IProcess
		{
			return ourParentProcess;
		}

		public function setHaltOnErrors(myHalt:Boolean):void
		{
			ourHaltOnErrors = myHalt;
		}

		public function getProgress():Number
		{
			var myNumerator:Number = ourCompletionPercentage;

			for (var i:Number = 0; i < ourSubProcesses.length; i++)
			{
				myNumerator += IProcess(ourSubProcesses[i]).getProgress();
			}
			return myNumerator / (ourSubProcesses.length + 1);
		}

		public function start(myParentProcess:IProcess = null):void
		{
			reset();
			for (var i:Number = 0; i < ourSubProcesses.length; i++)
			{
				ourSubProcesses[i].reset();
			}
			fireOnStartEvent();
			IProcess(this).process(myParentProcess);
		}

		public function reset():void
		{
			setProgress(0);
			ourSubProcessProcessor.reset();
		}

		public function getQueuedProcesses():Array
		{
			return ourSubProcessProcessor.getQueuedProcesses();
		}

		public function getProgressText():String
		{
			return getTextualPercentage() + " complete";
		}

		public function addSubProcess(myProcess:IProcess):void
		{

			ourSubProcesses.push(myProcess);

			ourSubProcessProcessor.addProcess(myProcess);

			if (ourSubProcessNameToSubProcess[myProcess.getProcessName()] == null)
				ourSubProcessNameToSubProcess[myProcess.getProcessName()] = [];

			ourSubProcessNameToSubProcess[myProcess.getProcessName()].push(myProcess);
			myProcess.setParentProcess(IProcess(this));
			//myProcess.addedAsSubProcess(IProcess(this));
		}

		public function getSubProcessesByName(myProcessName:String):Array
		{
			return ourSubProcessNameToSubProcess[myProcessName];
		}

		public function removeSubProcess(myProcess:IProcess):void
		{
			ArrayUtil.removeValueFromArray(ourSubProcesses, myProcess);
			ourSubProcessProcessor.removeProcess(myProcess);
		}

		public function removeSubProcessesOfType(myTypeClass:Class):void
		{
			var myArrayLength:uint = ourSubProcesses.length;

			for (var i:Number = myArrayLength - 1; i > -1; i--)
			{
				if (ourSubProcesses[i] is myTypeClass)
				{
					ourSubProcessProcessor.removeProcess(ourSubProcesses[i]);
					ourSubProcesses.splice(i, 1);
				}
			}

		}

		public function getProcessedResult():*
		{
			return {};
		}

		public function getRunningProcesses():Array
		{
			return ourSubProcessProcessor.getRunningProcesses();
		}

		protected function setProgress(myProgress:Number):void
		{
			ourCompletionPercentage = myProgress;
			fireOnProgressEvent();
		}

		protected function setProgressComplete():void
		{
			setProgress(1);
			if (ourSubProcessProcessor.isComplete())
				fireOnCompleteEvent();
		}

		protected function fireOnProgressEvent():void
		{
			var myEvent:Event = new ProcessEvent(ProcessEvent.PROGRESS);
			dispatchEvent(myEvent);
		}

		protected function fireOnStartEvent():void
		{
			var myEvent:Event = new ProcessEvent(ProcessEvent.START);
			dispatchEvent(myEvent);
		}

		protected function fireOnCompleteEvent():void
		{
			fireOnProgressEvent();
			var myEvent:Event = new ProcessEvent(ProcessEvent.COMPLETE);
			dispatchEvent(myEvent);
		}

		protected function getTextualPercentage():String
		{
			return Math.floor(getProgress() * 100) + "%";
		}

		protected function throwError(myError:Error):void
		{
			var myEvent:ProcessEvent = new ProcessEvent(ProcessEvent.ERROR);
			myEvent.error = myError;

			dispatchEvent(myEvent);
		}

		protected function complete():void
		{
			setProgressComplete();
		}

		protected function runSubProcesses(mySelfAlreadyCompleted:Boolean = false):void
		{
			if (mySelfAlreadyCompleted)
				complete();

			if (!ourSubProcessProcessor.isComplete())
				ourSubProcessProcessor.beginProcessing();
		}

		private function subProcessesComplete(myEvent:ProcessorEvent):void
		{
			fireOnCompleteEvent();
		}

		private function processorRequestingToRunProcess(myEvent:ProcessorEvent):void
		{
			myEvent.requestedProcessToRun.addEventListener(ProcessEvent.PROGRESS, subProcessProgress);
			myEvent.requestedProcessToRun.start(this as IProcess);
		}

		private function subProcessProgress(myEvent:ProcessEvent):void
		{
			fireOnProgressEvent();
		}
	}
}
