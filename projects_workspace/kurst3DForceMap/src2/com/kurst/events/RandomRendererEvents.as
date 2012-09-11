package com.kurst.events {
	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class RandomRendererEvents extends Event {
		public static const HIDE_TOGGLE : String = "RandomRendererEvents_HIDE_TOGGLE";
		public var visible : Boolean;

		public function RandomRendererEvents(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
