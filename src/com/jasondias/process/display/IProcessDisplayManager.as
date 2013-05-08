package com.jasondias.process.display
{
	public interface IProcessDisplayManager
	{
		function getIsVisible():Boolean;

		function getVisibleName():String;

		function setVisible():void;

		function setInvisible():void;
	}
}
