package com.kurst.events {
	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class StagePlayerEvent extends Event {
		public static const VIDEO_COMPLETE : String = "VIDEO_COMPLETE";
		public static const VIDEO_LOOP : String = "VIDEO_LOOP";
		public static const VIDEO_LOAD : String = "VIDEO_LOAD";
		public static const VIDEO_PLAY : String = "VIDEO_PLAY";
		public static const VIDEO_STOPPED : String = "VIDEO_STOPPED";
		public var progress : Number;
		public function StagePlayerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
