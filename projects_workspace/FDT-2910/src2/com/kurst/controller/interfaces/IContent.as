/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controller.interfaces.IContent
 * Version 	  	: 1
 * Description 	: Content Interface - all content views must implement these functions
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
 *	function activate():void;
 *	function deactivate():void;
 *	function refresh():void;
 *	function setData( obj:Object ):void;
 *	function resize(e:Event = null ):void;	
 *	function setSection( obj:Object ):void;	
 *	function destroy():void;	
 *	function pause():void;	
 *	function setSubSection( obj:Object ):void		
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.controller.interfaces {
	import flash.events.Event

	public interface IContent {
		
		/**
		 * @method activate()
		 * @tooltip activate content view 
		 */
		function activate() : void;

		/**
		 * @method deactivate()
		 * @tooltip deactivate content view
		 */
		function deactivate() : void;

		/**
		 * @method refresh()
		 * @tooltip refresh content view 
		 */
		function refresh() : void;

		/**
		 * @method setData( obj:Object )
		 * @tooltip assign data to a content view
		 */
		function setData(obj : Object) : void;

		/**
		 * @method resize(e:Event = null ):void
		 * @tooltip resize the content view 
		 */
		function resize(e : Event = null) : void;

		/**
		 * @method setSection( obj:Object ):void
		 * @tooltip assign section data to a content view
		 */
		function setSection(obj : Object) : void;

		/**
		 * @method destroy():void
		 * @tooltip destroy a content view
		 */
		function destroy() : void;

		/**
		 * @method pause():void
		 * @tooltip pause a content view
		 */
		function pause() : void;

		/**
		 * @method resume():void
		 * @tooltip resume a paused content view
		 */
		function resume() : void;

		/**
		 * @method setSubSection( obj:Object ):void
		 * @tooltip assign sub section info to a content view 
		 */
		function setSubSection(obj : Object) : void
	}
}