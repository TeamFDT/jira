/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.events.ContentProxyEvent
 * Version 	  	: 1
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 23/10/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * EVENTS
 * 
 * 		CONTENT_ACTION
 * 
 * PROPERTIES
 * 
 * 		action() : String
 * 		params() : Array
 * 
 ********************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************/
package com.kurst.events {
	import flash.events.Event;

	public class ContentProxyEvent extends Event {
		public static const CONTENT_ACTION : String = "ContentProxyEvent_CONTENT_ACTION";
		private var _action : String;
		private var _params : Array;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------
		// CONSTRUCTOR
		public function ContentProxyEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// GGGGG  EEEEEEE TTTTTT          SSSSS EEEEEEE TTTTTT
		// GG      EE        TT           SS     EE        TT
		// GG  GGG EEEE      TT            SSSS  EEEE      TT
		// GG   GG EE        TT               SS EE        TT
		// GGGGG  EEEEEEE   TT           SSSSS  EEEEEEE   TT
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 */
		public function get action() : String {
			return _action;
		}

		public function set action(action : String) : void {
			_action = action;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 */
		public function get params() : Array {
			return _params;
		}

		public function set params(params : Array) : void {
			_params = params;
		}
	}
}