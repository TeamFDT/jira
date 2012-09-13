/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controller.Controller
 * Version 	  	: 1
 * Description 	: Site Controller
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Kb
 * Date 			: 31/03/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	loadSiteStructure( uri : String ) : void 
 * 	destroy():void
 * 
 * 	Inherited:
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
 *
 * EVENTS
 * 
 * 	LoadEvent.LOADED_SITE_STRUCTURE
 * 	
 * EVENT HANDLERS
 * 
 * 	NavigationProxy.navigateTo( 'route' )
 * 		>> NavigationRequestEvent.NAVIGATE
 * 		
 * 	ContentProxy.dispatchAction(action)
 * 		>> ContentProxyEvent.CONTENT_ACTION
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.controller {
	import com.kurst.controller.content.Container;
	import com.kurst.controller.interfaces.IContent;
	import com.kurst.controller.model.SectionsData;
	import com.kurst.controller.utils.ContentProxy;
	import com.kurst.controller.utils.NavigationProxy;
	import com.kurst.events.ContentProxyEvent;
	import com.kurst.events.LoadEvent;
	import com.kurst.events.NavigationRequestEvent;

	public class Controller extends Container implements IContent {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function Controller() {
			NavigationProxy.getInstance().addEventListener(NavigationRequestEvent.NAVIGATE, NavigationRequest, false, 0, true);
			ContentProxy.getInstance().addEventListener(ContentProxyEvent.CONTENT_ACTION, ContentProxyAction, false, 0, true);
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
		 * @method 
		 * @tooltip 
		 */
		public function loadSiteStructure(uri : String) : void {
			// load the site structure
			SectionsData.loadSiteStructure(uri).addEventListener(LoadEvent.LOADED_DATA, SectionDataLoaded, false, 0, true);
		}

		/**
		 * @method 
		 * @tooltip 
		 */
		override public function destroy() : void {
			NavigationProxy.getInstance().removeEventListener(NavigationRequestEvent.NAVIGATE, NavigationRequest);
			ContentProxy.getInstance().removeEventListener(ContentProxyEvent.CONTENT_ACTION, ContentProxyAction);
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
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// EEEEEEE V     V EEEEEEE NN  NN TTTTTT         HH   HH   AAA   NN  NN DDDDDD  LL      EEEEEEE RRRRR    SSSSS
		// EE      V     V EE      NNN NN   TT           HH   HH  AAAAA  NNN NN DD   DD LL      EE      RR  RR  SS
		// EEEE     V   V  EEEE    NNNNNN   TT           HHHHHHH AA   AA NNNNNN DD   DD LL      EEEE    RRRRR    SSSS
		// EE        V V   EE      NN NNN   TT           HH   HH AAAAAAA NN NNN DD   DD LL      EE      RR  RR      SS
		// EEEEEEE    V    EEEEEEE NN  NN   TT           HH   HH AA   AA NN  NN DDDDDD  LLLLLLL EEEEEEE RR   RR SSSSS
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip 
		 */
		private function SectionDataLoaded(e : LoadEvent) : void {
			SectionsData.getInstance().removeEventListener(LoadEvent.LOADED_DATA, SectionDataLoaded);
			dispatchEvent(new LoadEvent(LoadEvent.LOADED_SITE_STRUCTURE));
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param  
		 */
		private function NavigationRequest(e : NavigationRequestEvent) : void {
			
			// OVERRIDE - NAVIGATION REQUEST
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param  
		 */
		private function ContentProxyAction(e : ContentProxyEvent) : void {
			if ( this.hasOwnProperty(e.action) ) {
				var fnc : Function = this[ e.action ]
				fnc.apply(this, e.params);
			}
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
	}
}