package com.kurst.controls.video.events {
	import flash.events.Event;

	/**
	 * @author karimbeyrouti
	 */
	public class VideoBufferEvent extends Event {
		public static const BUFFER_LOADED : String = "BUFFER_LOADED";
		public static const BUFFER_PROGRESS : String = "BUFFER_PROGRESS";
		public var progress : Number;

		public function VideoBufferEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone() : Event {
			var e : VideoBufferEvent = new VideoBufferEvent(type);
			e.progress = progress;
			return e;
		}
	}
}
