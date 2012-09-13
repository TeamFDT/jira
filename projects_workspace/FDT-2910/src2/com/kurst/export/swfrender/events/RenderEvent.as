package com.kurst.export.swfrender.events {
	import com.kurst.export.swfrender.data.ErrorMessage;
	import com.kurst.export.swfrender.settings.RenderSettings;

	import flash.events.Event;

	public class RenderEvent extends Event {
		public static const START_RENDER : String = "RenderEvent_START_CAPTURE";
		public static const STOP_RENDER : String = "RenderEvent_STOP_CAPTURE";
		public static const ON_RENDER_FRAME : String = "RenderEvent_ON_RENDER_FRAME"
		public static const RENDER_COMPLETE : String = "RenderEvent_RENDER_COMPLETE";
		public static const SELECT_NEXT_FILE : String = "RenderEvent_SELECT_NEXT_FILE";
		public var frame : int;
		public var settings : RenderSettings;
		public var totalFiles : int;
		public var currentFile : int;
		public var errorMessages : Vector.<ErrorMessage>;
		public var totalSuccess : int;

		public function RenderEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone() : Event {
			var e : RenderEvent = new RenderEvent(type, bubbles, cancelable);

			e.frame = frame;
			e.settings = settings;
			e.totalFiles = totalFiles;
			e.currentFile = currentFile;
			e.errorMessages = errorMessages
			e.totalSuccess = totalSuccess;

			return e;
		}
	}
}
