package com.jasondias.process.processor
{
	import com.jasondias.process.IProcess;
	import com.jasondias.process.event.ProcessEvent;
	import com.jasondias.utils.ArrayUtil;

	public class PoolProcessor extends AbstractProcessor implements IProcessor
	{
		private var ourRunningPool:Array;
		private var ourQueue:Array;
		private var ourPoolSize:Number;
		private var ourSubProcesses:Array;

		function PoolProcessor(myPoolSize:Number = 3)
		{
			ourRunningPool = [];
			ourPoolSize = myPoolSize;
			ourQueue = [];
			ourSubProcesses = [];
		}

		public static function getSerialProcessor():PoolProcessor
		{
			return new PoolProcessor(1);
		}

		public function getRunningProcesses():Array
		{
			return ourRunningPool;
		}

		public function getQueuedProcesses():Array
		{
			return ourQueue;
		}

		public function addProcess(myProcess:IProcess):void
		{
			//ourIsComplete = false;
			ourSubProcesses.push(myProcess);
			ourQueue.push(myProcess);
		}

		public function beginProcessing():void
		{
			if (!isComplete())
				fillPool();
		}

		public function clearProcesses():void
		{
			ourQueue = [];
			ourSubProcesses = [];
		}

		public function reset():void
		{
			ourQueue = ArrayUtil.copyArray(ourSubProcesses);
			ourRunningPool = [];
		}

		public function isComplete():Boolean
		{
			return ourQueue.length == 0 && ourRunningPool.length == 0;
		}

		public function removeProcess(myProcess:IProcess):void
		{
			ArrayUtil.removeValueFromArray(ourQueue, myProcess);
			ArrayUtil.removeValueFromArray(ourSubProcesses, myProcess);

			if (ourRunningPool.indexOf(myProcess) >= 0)
			{
				throw new Error("Cannot remove a process that is currently running.");
			}
		}

		public function getProcessIndex(myProcess:IProcess):Number
		{
			return ourSubProcesses.indexOf(myProcess);
		}

		private function fillPool():void
		{
			if (ourRunningPool.length <= 0 && ourQueue.length <= 0)
			{
				fireOnProcessingComplete();
				return;
			}

			while (ourRunningPool.length < Math.min(ourPoolSize, ourQueue.length))
			{
				var myNextProcess:IProcess = ourQueue.shift();
				ourRunningPool.push(myNextProcess);

				runProcess(myNextProcess);
			}

		}

		private function displayQueue():void
		{
			trace("------------------------");
			trace("Running...");
			for (var i:Number = 0; i < ourRunningPool.length; i++)
			{
				trace("  " + IProcess(ourRunningPool[i]).getProcessName());
			}

			trace("");
			trace("Queue...");
			for (var j:Number = 0; j < ourQueue.length; j++)
			{
				trace("  " + IProcess(ourQueue[j]).getProcessName());
			}

			trace("");
			trace("Sub Processes...");
			for (var k:Number = 0; k < ourSubProcesses.length; k++)
			{
				trace("  " + IProcess(ourSubProcesses[k]).getProcessName());
			}

		}

		private function runProcess(myProcess:IProcess):void
		{
			myProcess.addEventListener(ProcessEvent.COMPLETE, subProcessComplete);
			fireOnRequestProcessRun(myProcess);
		}

		private function disconnectProcess(myProcess:IProcess):void
		{
			myProcess.removeEventListener(ProcessEvent.COMPLETE, subProcessComplete);
		}

		private function subProcessComplete(myEvent:ProcessEvent):void
		{
			ArrayUtil.removeValueFromArray(ourRunningPool, myEvent.target);
			disconnectProcess(IProcess(myEvent.target));
			fillPool();
		}
	}
}
