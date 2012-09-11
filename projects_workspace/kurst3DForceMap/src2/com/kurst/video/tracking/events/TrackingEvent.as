/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: 
 * Date 			: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 *
 * PROPERTIES
 * 
 *
 * EVENTS
 * 
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			: -default-background-color #000000
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.events {
	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.data.TrackData;

	import flash.events.Event;

	public class TrackingEvent extends Event {
		public static const LOAD_COMPLETE : String = "LOAD_COMPLETE";
		public static const LOAD_ITEM_COMPLETE : String = "LOAD_ITEM_COMPLETE";
		public static const START_TRACKER : String = "START_TRACKER";
		public static const STOP_TRACKER : String = "STOP_TRACKER";
		public var data : TrackData;
		public var tracker : Tracker;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackingEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone() : Event {
			var e : TrackingEvent = new TrackingEvent(type, bubbles, cancelable);
			e.data = data;
			e.tracker = tracker;
			return e;
		}
	}
}