package com.adobe.air.filesystem.events
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class FileMonitorEvent extends Event
	{
		public static const CHANGE:String = "onFileChange";
		public static const MOVE:String = "onFileMove";
		public static const CREATE:String = "onFileCreate";
		public static const ADD_VOLUME:String = "onVolumeAdd";
		public static const REMOVE_VOLUME:String = "onVolumeRemove";
		
		public var file:File;
		public function FileMonitorEvent(type:String, bubbles:Boolean=false, 
				ancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var out:FileMonitorEvent = new FileMonitorEvent(type, bubbles, cancelable);
			out.file = file;
			
			return out;
		}
	}
}