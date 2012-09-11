/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.data.xmlLoader
 * Version 	  	: 1
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 03/01/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 		load( URI:String):void
 *		clean( ):void
 * 
 * PROPERTIES
 * 
 * 		data - get only
 * 		dataLoaded
 *
 * EVENTS
 * 
 * 		 LoadEvent.LOADED_XML 
 * 
 ********************************************************************************************************************************************************************************
 * TODO			:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:

	import com.kurst.data.xmlLoader

	var xmlL:xmlLoader = new xmlLoader();
		xmlL.load( "books.xml" );
		xmlL.addEventListener("onXmlLoaded", onXmlLoaded);

	var dP:DataProvider = new DataProvider()

	function onXmlLoaded( event:Event ){
		
		trace( event.target.data  );// trace the XML
		
		xmlL.removeEventListener( "onXmlLoaded", onXmlLoaded);// remove the event listener
		xmlL.clean();// make sure the event listener is removed
		xmlL = null;

	}

 **********************************************************************************************************************************************************************************/
package com.kurst.loading {
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import com.kurst.events.CEventDispatcher;
	import com.kurst.events.LoadEvent

	public class XmlLoader extends CEventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _xmlLoader : URLLoader;
		private var _xmlData : XML;
		private var _dataLoaded : Boolean = false;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function XmlLoader() {
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onCompleteXML, false, 0, true);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			_xmlData = new XML();
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
		 * @method load( URI:String):void
		 * @tooltip
		 * @param
		 * @return
		 */
		public function load(URI : String) : void {
			_dataLoaded = false;
			_xmlLoader.load(new URLRequest(URI));
		}

		/**
		 * @method clean( )
		 * @tooltip
		 * @param
		 * @return
		 */
		public function clean() : void {
			_xmlLoader.removeEventListener(Event.COMPLETE, onCompleteXML);

			_xmlLoader = null;
			_xmlData = null;
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
		 * @method data()
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get dataLoaded() : Boolean {
			return _dataLoaded;
		}

		/**
		 * @method data()
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get data() : XML {
			return _xmlData;
		}

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
		 * @method onCompleteXML( e:Event )
		 * @tooltip
		 * @param
		 * @return
		 */
		private function onCompleteXML(e : Event) : void {
			_dataLoaded = true ;
			_xmlLoader.removeEventListener(Event.COMPLETE, onCompleteXML);
			_xmlData = new XML(e.target.data);

			var ev : LoadEvent = new LoadEvent(LoadEvent.LOADED_XML);
			dispatchEvent(ev);
		}

		/**
		 * @method onCompleteXML( e:Event )
		 * @tooltip
		 * @param
		 * @return
		 */
		private function onLoadError(event : IOErrorEvent) : void {
			var ev : LoadEvent = new LoadEvent(LoadEvent.XML_LOAD_ERROR);
			dispatchEvent(ev);
		}
	}
}
