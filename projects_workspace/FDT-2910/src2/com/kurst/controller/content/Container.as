/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controller.content.Container
 * Version 	  	: 1 
 * Description 	: Content class 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 10/11/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 *		pause
 *		resume
 *		activate
 *		deactivate
 *		refresh
 *		setData( obj:Object )
 *		resize
 *		destroy
 *		setSection( sectionID:Object )
 *		setSubSection( subSectionID:Object )
 *
 **********************************************************************************************************************************************************************************/
package com.kurst.controller.content {
	import com.kurst.controller.interfaces.IContent;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class Container extends MovieClip implements IContent {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function Container() {
		}

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
		 * @method pause()
		 * @tooltip pause a section
		 */
		public function pause() : void {
			// MARKED FOR OVERRIDE
		}
		/**
		 * @method pause()
		 * @tooltip pause a section
		 */
		public function resume() : void {
			// MARKED FOR OVERRIDE
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * @method activate()
		 * @tooltip activate a section
		 */
		public function activate() : void {
			// MARKED FOR OVERRIDE
		}
		/**
		 * @method deactivate()
		 * @tooltip deactivate a section 
		 */
		public function deactivate() : void {
			// MARKED FOR OVERRIDE
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method refresh()
		 * @tooltip refresh a section 
		 */
		public function refresh() : void {
			// MARKED FOR OVERRIDE
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * @method setData( obj:Object )
		 * @tooltip assign data to a content view
		 */
		public function setData(obj : Object) : void {
			// MARKED FOR OVERRIDE
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * @method resize(e:Event = null ):void
		 * @tooltip resize the content view 
		 */
		public function resize(e : Event = null) : void {
			// MARKED FOR OVERRIDE
		}
		/**
		 * @method setSection( obj:Object ):void
		 * @tooltip assign section data to a content view
		 */
		public function destroy() : void {
			// MARKED FOR OVERRIDE
		}
		/**
		 * @method setSection( obj:Object ):void
		 * @tooltip assign section data to a content view
		 */
		public function setSection(sectionID : Object) : void {
			// MARKED FOR OVERRIDE
		}
		/**
		 * @method setSubSection( obj:Object ):void
		 * @tooltip assign sub section info to a content view 
		 */
		public function setSubSection(subSectionID : Object) : void {
			// MARKED FOR OVERRIDE
		}
	
	}
}