/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.utils.ContentProxy
 * Version 	  	: 1
 * Description 	: Send content actions to a controller / Proxy used to minimize includes in content calls to main /
 * 					external controllers
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti 
 * Date 			: 10/11/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * STATIC
 * 
 * 	ContentProxy.sendAction( action:String , params:Array = null ):void
 *
 * EVENTS
 * 
 * 	ContentProxyEvent.CONTENT_ACTION
 * 
 ********************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************/
package com.kurst.controller.utils {
	import flash.events.EventDispatcher;

	import com.kurst.events.ContentProxyEvent;

	public class ContentProxy extends EventDispatcher {
		
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
		
		static private var __ContentProxy : ContentProxy;
		/**
		 * @method dispatchAction( action:String , params:Array = null ):void
		 * @tooltip dispatch an action to the controller or listening object 
		 * @param action : String - name of function
		 * @param params : Array - parameter to pass to the function
		 */
		public static function dispatchAction(action : String, params : Array = null) : void {
			getInstance()._dispatchAction(action, params);
		}
		/**
		 * @method getInstance()
		 * @tooltip
		 * @param
		 */
		public static function getInstance() : ContentProxy {
			if ( __ContentProxy == null ) {
				__ContentProxy = new ContentProxy();
			}

			return __ContentProxy;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		public function ContentProxy() {}

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
		 * @method _dispatchAction( a:String , p:Array = null ):void
		 * @tooltip dispatch the action call
		 * @param action : String - name of function
		 * @param params : Array - parameter to pass to the function
		 */
		public function _dispatchAction(a : String, p : Array = null) : void {
			var e : ContentProxyEvent = new ContentProxyEvent(ContentProxyEvent.CONTENT_ACTION);
			e.action = a
			e.params = p
			dispatchEvent(e);
		}
	}
}