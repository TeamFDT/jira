/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controller.interfaces.IController
 * Version 	  	: 1
 * Description 	: Controller interface - all controller views must implement these functions
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Kb 
 * Date 			: 28/03/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	ContentProxyAction( e:ContentProxyEvent ):void
 * 	function NavigationRequest( e:NavigationRequestEvent ):void
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
package com.kurst.controller.interfaces {
	import com.kurst.events.ContentProxyEvent
	import com.kurst.events.NavigationRequestEvent

	public interface IController {
		
		/**
		 * @method ContentProxyAction( e:ContentProxyEvent ):void
		 * @tooltip 
		 */
		function ContentProxyAction(e : ContentProxyEvent) : void;

		/**
		 * @method NavigationRequest( e:NavigationRequestEvent ):void
		 * @tooltip 
		 */
		function NavigationRequest(e : NavigationRequestEvent) : void
	
	}
}