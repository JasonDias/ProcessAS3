package com.jasondias.process.display
{
	import com.jasondias.process.IProcess;

	public class ProcessDisplayManager implements IProcessDisplayManager
	{
		private var ourProcess:IProcess;
		private var ourIsVisible:Boolean;

		function ProcessDisplayManager(myProcess:IProcess)
		{
			ourProcess = myProcess;
			setVisible();
		}

		static public function makeVisible(myProcess:IProcess):IProcess
		{
			myProcess.getProcessDisplayManager().setVisible();
			return myProcess;
		}

		static public function makeInvisible(myProcess:IProcess):IProcess
		{
			myProcess.getProcessDisplayManager().setInvisible();
			return myProcess;
		}

		public function getIsVisible():Boolean
		{
			return ourIsVisible;
		}

		public function getVisibleName():String
		{
			return ourProcess.getProcessName();
		}

		public function setVisible():void
		{
			ourIsVisible = true;
		}

		public function setInvisible():void
		{
			ourIsVisible = false;
		}
	}
}
