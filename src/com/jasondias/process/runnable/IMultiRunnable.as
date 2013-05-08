package com.jasondias.process.runnable
{
	public interface IMultiRunnable extends IRunnable
	{
		function addRunnable(myRunnable:IRunnable):void;

		function removeRunnable(myRunnable:IRunnable):void;

		function removeAllRunnable():void;
	}
}
