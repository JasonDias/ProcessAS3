package com.jasondias.process.processes
{
	import com.jasondias.process.AbstractProcess;
	import com.jasondias.process.processor.IProcessor;

	public class AbstractDynamicallyNamedProcess extends AbstractProcess
	{
		private var ourProcessName:String;

		function AbstractDynamicallyNamedProcess(myProcessor:IProcessor = null)
		{
			super(myProcessor);
		}

		public function getProcessName():String
		{
			return ourProcessName;
		}

		public function setProcessName(myProcessName:String):void
		{
			ourProcessName = myProcessName;
		}
	}
}
