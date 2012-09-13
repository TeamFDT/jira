package com.kurst.events {
	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class MobileAppControllerEvent extends Event {
		public static const DEACTIVATE_APP : String = "DEACTIVATE_APP";
		public static const ACTIVATE_APP : String = "ACTIVATE_APP";
		public function MobileAppControllerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
