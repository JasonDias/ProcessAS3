package com.jasondias.process.processes
{
	import com.jasondias.process.IProcess;
	import com.jasondias.process.processor.IProcessor;

	public class EmptyProcess extends AbstractDynamicallyNamedProcess implements IProcess
	{

		function EmptyProcess(myName:String, myProcessor:IProcessor = null)
		{
			super(myProcessor);
			setProcessName(myName);
		}

		public function process(myParentProcess:IProcess = null):void
		{
			runSubProcesses(true);
		}


	}
}
