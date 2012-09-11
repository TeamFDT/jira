/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.tracking.gaTracker
 * Version 	  	: 1
 * Description 	: Urching Tracker - works with google analitics
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim beyrouti
 * Date 			: 10/10/07
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS - STATIC
 * 
 * 	gaTracker.setDebug( Boolean );
 * 	gaTracker.getDebug( ):Boolean;
 * 	gaTracker.track( param1, sub_param2, sub_sub_param3, ... ):Void;
 * 		ouputs the following tracking string to the gaTracker "param1/sub_param2/sub_sub_param3/"
 * 		
 **********************************************************************************************************************************************************************************/
package com.kurst.tracking {
	import com.kurst.utils.LocationUtil;

	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.Timer;

	public class gaTracker {
		private static var __gaTracker : gaTracker;

		// -STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// SSSSS TTTTTT   AAA   TTTTTT IIIIII  CCCCC
		// SS       TT    AAAAA    TT     II   CC   CC
		// SSSS    TT   AA   AA   TT     II   CC
		// SS   TT   AAAAAAA   TT     II   CC   CC
		// SSSSS    TT   AA   AA   TT   IIIIII  CCCCC
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method debug
		 * @tooltip 
		 * @param 
		 */
		static public function setDebug(flag : Boolean) : void {
			getInstance()._setDebug(flag);
		}

		/**
		 * @method debug
		 * @tooltip 
		 * @param 
		 */
		static public function getDebug() : Boolean {
			return getInstance()._getDebug();
		}

		/**
		 * @method track
		 * @tooltip add a tracking event
		 * @param str - tracking string
		 */
		static public function track(...arguments) : void {
			var str : String = "";
			var l : Number = arguments.length;

			arguments.reverse();

			while ( l-- ) {
				str += "/" + arguments[l]
			}

			getInstance()._track(str + "/");
		}

		/**
		 * @method track
		 * @tooltip add a tracking event
		 * @param str - tracking string
		 */
		static public function trackNow() : void {
			var str : String = "";
			var l : Number = arguments.length;

			arguments.reverse();

			while ( l-- )
				str += "/" + arguments[l]

			getInstance().sendURLevent(str + "/");
		}

		/**
		 * getInstance
		 * 
		 * @usage  getInstance()._track( "t/s/" );
		 * @return static instance of the urchinTracker class
		 */
		static public function getInstance() : gaTracker {
			if ( __gaTracker == null ) {
				__gaTracker = new gaTracker();
			}

			return __gaTracker;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var getURL_queue : Array
		private var getURL_delay : Number = 45
		private var fDebug : Boolean = false;
		private var timer : Timer

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -CONSTRUCTOR-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// CCCCC   OOOO  NN  NN  SSSSS TTTTTT RRRRR   UU   UU  CCCCC  TTTTTT  OOOO  RRRRR
		// CC   CC OO  OO NNN NN SS       TT   RR  RR  UU   UU CC   CC   TT   OO  OO RR  RR
		// CC      OO  OO NNNNNN  SSSS    TT   RRRRR   UU   UU CC        TT   OO  OO RRRRR
		// CC   CC OO  OO NN NNN     SS   TT   RR  RR  UU   UU CC   CC   TT   OO  OO RR  RR
		// CCCCC   OOOO  NN  NN SSSSS    TT   RR   RR  UUUUU   CCCCC    TT    OOOO  RR   RR
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		function gaTracker() {
			getURL_queue = new Array();
			timer = new Timer(getURL_delay);

			timer.addEventListener(TimerEvent.TIMER, queueInterval, false, 0, true);
		}

		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  RRRRR   IIIIII V     V   AAA   TTTTTT EEEEEEE
		// PP   PP RR  RR    II   V     V  AAAAA    TT   EE
		// PPPPPP  RRRRR     II    V   V  AA   AA   TT   EEEE
		// PP      RR  RR    II     V V   AAAAAAA   TT   EE
		// PP      RR   RR IIIIII    V    AA   AA   TT   EEEEEEE
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method _track
		 * @tooltip add a tracking event
		 * @param str - tracking string
		 */
		private function _setDebug(flag : Boolean) : void {
			fDebug = flag
		}

		/**
		 * @method _track
		 * @tooltip add a tracking event
		 * @param str - tracking string
		 */
		private function _getDebug() : Boolean {
			return fDebug
		}

		/**
		 * @method _track
		 * @tooltip add a tracking event
		 * @param str - tracking string
		 */
		private function _track(str : String) : void {
			addToQueue(str);
		}

		/**
		 * @method addToQueue( str )
		 * @tooltip add a tracking event to the queue 
		 * @param str - tracking string
		 */
		private function addToQueue(str : String) : void {
			getURL_queue.push(str);
			startQueueInterval();
		}

		/**
		 * @method startQueueInterval
		 * @tooltip start a queue interval loop
		 */
		private function startQueueInterval() : void {
			stopQueueInterval();
			timer.start();
			// getURL_iid = setInterval( this, "queueInterval", getURL_delay);
		}

		/**
		 * @method stopQueueInterval
		 * @tooltip stop a queue interval loop
		 */
		private function stopQueueInterval() : void {
			timer.stop();
		}

		/**
		 * @method queueInterval
		 * @tooltip queue interval
		 */
		private function queueInterval(e : TimerEvent) : void {
			if ( getURL_queue.length > 0 ) {
				sendURLevent(String(getURL_queue.shift()));
			} else {
				stopQueueInterval();
			}
		}

		/**
		 * @method sendURLevent
		 * @tooltip send a tracking URL event
		 * @param str - tracking string
		 */
		private function sendURLevent(str : String) : void {
			if ( fDebug ) {
				trace("gaTracker.trackPageview(" + str + ");");
			}

			if ( LocationUtil.isAirApplication() || Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") {
			} else {
				try {
					ExternalInterface.call("pageTracker._trackPageview", str);
					ExternalInterface.call("TrackHit", str);
					// Added for maynard Malone - Tracking
				} catch(e : Error) {
					trace(e);
				}
			}
		}
	}
}