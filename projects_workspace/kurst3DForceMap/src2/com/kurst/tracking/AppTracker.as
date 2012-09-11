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

	public class AppTracker extends Sprite {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static var inst : AppTracker;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function enableTracking(flag : Boolean) : void {
			getInstance().enable = flag;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function setDebug(flag : Boolean) : void {
			getInstance().debug = flag;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function init(mc : Stage, userAccount : String) : void {
			getInstance()._init(mc, userAccount);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function track(str : String) : void {
			getInstance()._trackClick(str);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function getInstance() : AppTracker {
			if ( inst == null ) {
				inst = new AppTracker()
			}

			return inst ;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function setTrackingBase(str : String) : void {
			getInstance()._setTrackingBase(str);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _enabled : Boolean = true;
		private var _debug : Boolean = false;
		private var _tracker : GATracker
		private var _trackBase : String = ''

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function AppTracker() {
			super();

			// _firstRun = ( ApplicationSettingsData.getSetting( Constants.ConfigSettings_FirstRun ) == null ) ? true : ApplicationSettingsData.getSetting( Constants.ConfigSettings_FirstRun ) as Boolean;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function _setTrackingBase(str : String) : void {
			_trackBase = str;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function _trackClick(str : String) : void {
			if ( _enabled )
				_tracker.trackPageview(_trackBase + '/' + str);

			if ( _debug )
				trace('AppTracker._trackClick(' + _trackBase + '/' + str + ')');
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function _init(mc : Stage, userAccount : String) : void {
			if ( _enabled )
				_tracker = new GATracker(mc, userAccount, "AS3", false);

			if ( _debug )
				trace('AppTracker.STATUS Enabled:' + _enabled + ' DEBUG: ' + _debug);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get enable() : Boolean {
			return _enabled;
		}

		public function set enable(flag : Boolean) : void {
			_enabled = flag;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get debug() : Boolean {
			return _debug;
		}

		public function set debug(debug : Boolean) : void {
			_debug = debug;
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}