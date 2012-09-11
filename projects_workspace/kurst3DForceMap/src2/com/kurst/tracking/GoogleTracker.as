/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
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
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.tracking {
	import com.google.analytics.GATracker;

	import flash.display.Sprite;
	import flash.display.Stage;

	public class GoogleTracker extends Sprite {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static var inst : GoogleTracker;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function setDebug(flag : Boolean) : void {
			getInstance().debug = flag;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function init(mc : Stage, trackCode : String) : void {
			getInstance()._init(mc, trackCode);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function trackClick(str : String) : void {
			getInstance()._trackClick(str);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getInstance() : GoogleTracker {
			if ( inst == null ) {
				inst = new GoogleTracker();
			}

			return inst ;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _tracker : GATracker;
		private var _enabled : Boolean = true;
		private var _debug : Boolean = false;
		private var _trackBase : String = '';
		private var _firstRun : Boolean = true;
		private var _trackCode : String = '';

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function GoogleTracker() {
			super();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function _trackClick(str : String) : void {
			if (_tracker) {
				if ( !_debug ) {
					// Only track if not in debug mode

					_tracker.trackPageview(_trackBase + str);
				}

				if ( _debug )
					trace('GoogleTracker._trackClick(' + str + ')');
			} else {
				trace('GoogleTracker (' + str + ') - NOT INITIALISED');
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function _init(mc : Stage, trackCode : String) : void {
			_trackCode = trackCode;

			// AppAnalytics.start(_key, _appID , false)

			_tracker = new GATracker(mc, _trackCode, "AS3", false);

			/*
			if ( _firstRun ){
				
			_firstRun = false;

			// _trackClick( _trackBase + 'START/FirstRun' )
			
				
			} else {
				
			// _trackClick( _trackBase + 'START/Run' )
				
			}
			 */
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get debug() : Boolean {
			return _debug;
		}

		public function set debug(debug : Boolean) : void {
			_debug = debug;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get enabled() : Boolean {
			return _enabled;
		}

		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get firstRun() : Boolean {
			return _firstRun;
		}

		public function set firstRun(firstRun : Boolean) : void {
			_firstRun = firstRun;
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
} 