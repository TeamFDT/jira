/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.wc.global.content
 * Version 	  	: 1
 * Description 	: NavigationProxy all navigation requests should be made via the NavigationProxy
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti 
 * Date 			: 23/10/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * STATIC
 * 
 * 	navigateTo(route : String) : void 
 * 	getCurrentRoute() : String
 * 	setCurrentRoute(route : String) : void
 * 	
 *
 * EVENTS
 * 
 * 
 ********************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************/
package com.kurst.controller.utils {
	import flash.events.EventDispatcher;

	import com.kurst.events.NavigationRequestEvent

	public class NavigationProxy extends EventDispatcher {
		
		// -STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// SSSSS TTTTTT   AAA   TTTTTT IIIIII  CCCCC
		// SS       TT    AAAAA    TT     II   CC   CC
		// SSSS    TT   AA   AA   TT     II   CC
		// SS   TT   AAAAAAA   TT     II   CC   CC
		// SSSSS    TT   AA   AA   TT   IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		static private var __NavigationProxy : NavigationProxy;
		/**
		 * @method enableNav( flag:Boolean )
		 * @tooltip navigation call - navigation to a section
		 * @param route : String - section to navigate to
		 */
		public static function navigateTo(route : String) : void {
			getInstance()._navigateTo(route);
		}
		/**
		 * @method getCurrentRoute() : String
		 * @tooltip get the current section
		 */
		public static function getCurrentRoute() : String {
			return getInstance().currentRoute;
		}
		/**
		 * @method setCurrentRoute(route : String) : void
		 * @tooltip set the current section
		 * @param route : String - 
		 */
		public static function setCurrentRoute(route : String) : void {
			getInstance().currentRoute = route;
		}
		/**
		 * @method getInstance():NavigationProxy
		 * @tooltip get navigation proxy instance
		 */
		public static function getInstance() : NavigationProxy {
			if ( __NavigationProxy == null ) {
				__NavigationProxy = new NavigationProxy();
			}

			return __NavigationProxy;
		}
		private var _currentRoute : String;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		public function NavigationProxy() { }

		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  UU   UU BBBBBB  LL      IIIIII  CCCCC
		// PP   PP UU   UU BB   BB LL        II   CC   CC
		// PPPPPP  UU   UU BBBBBB  LL        II   CC
		// PP      UU   UU BB   BB LL        II   CC   CC
		// PP       UUUUU  BBBBBB  LLLLLLL IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @method enableNav( flag:Boolean )
		 * @tooltip navigation call - navigation to a section
		 * @param route : String - section to navigate to
		 */
		public function _navigateTo(route : String) : void {
			var e : NavigationRequestEvent = new NavigationRequestEvent(NavigationRequestEvent.NAVIGATE);
			e.uri = route;
			dispatchEvent(e);
		}
		/**
		 * @method getCurrentRoute() : String
		 * @tooltip get the current section
		 */
		public function get currentRoute() : String {
			return _currentRoute;
		}
		/**
		 * @method getInstance():NavigationProxy
		 * @tooltip get navigation proxy instance
		 */
		public function set currentRoute(route : String) : void {
			_currentRoute = route;
		}
	}
}