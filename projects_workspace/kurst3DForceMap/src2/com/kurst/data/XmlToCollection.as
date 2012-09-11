/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.data.XmlToDataObject
 * Version 	  	: 1
 * Description 	: create a DataObject from an XML document
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
 * 		load( URI:String )
 * 		clean( )
 * 		parseXML( xml:XML )
 *
 * PROPERTIES
 *
 * 		data - get only
 *
 * EVENTS
 * 
 * 		LoadEvent.LOADED_DATA
 * 
 * 
 ********************************************************************************************************************************************************************************
 *********************************************************************************************************************************************************************************
 * NOTES			:

	import com.kurst.data.xmlToDataObject;
	import fl.controls.ComboBox;
	import com.kurst.events.LoadEvent
 
	function onDataLoaded( event:Object ) {
		
		dg_mc.dataProvider 	= xmlToDAO.data;
			
	}
		
	var xmlToDAO:xmlToDataObject = new xmlToDataObject()
		xmlToDAO.addEventListener( LoadEvent.LOADED_DATA, onDataLoaded );
		xmlToDAO.load( "books.xml" );
		
 **********************************************************************************************************************************************************************************/
package com.kurst.data {
	import com.kurst.events.CEventDispatcher;
	import com.kurst.events.LoadEvent;
	import com.kurst.loading.XmlLoader;
	import com.kurst.utils.StrUtils;

	import mx.collections.ArrayCollection;

	public class XmlToCollection extends CEventDispatcher {
		private var _xmlLoader : XmlLoader;
		private var _DataProvider : ArrayCollection;
		private var _DataProviderGroup : Object;
		private var _multiXmlFileFlag : Boolean = false;
		private var _customDataClass : Class;

		public function XmlToCollection() {
			//
			// trace( '_customDataClass: ' , _customDataClass );
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
		 * @method  load( URI:String )
		 * @tooltip load an XML file
		 * @param URI - URI of XMl file
		 */
		public function load(URI : String, multiXmlFileFlag : Boolean = false) : void {
			_multiXmlFileFlag = multiXmlFileFlag;

			_xmlLoader = new XmlLoader();
			_xmlLoader.addEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
			_xmlLoader.load(URI);
		}

		/**
		 * @method clean( )
		 * @tooltip clean / delete internal variables of the class
		 */
		public function clean() : void {
			_xmlLoader.removeEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
			_xmlLoader.clean();
			_xmlLoader = null;
		}

		/**
		 * @method parseXML( xml:XML )
		 * @tooltip parse XMl to a Data object
		 * @param XML data to parse
		 */
		public function parseXML(xml : XML) : void {
			_parseXML(xml);
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param 
		 */
		public function enumerateGroups() : Array {
			var r : Array = new Array();

			for ( var i : String in _DataProviderGroup )
				r.push(i) ;

			return r;
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param 
		 */
		public function getGroup(name : String) : ArrayCollection {
			return _DataProviderGroup[ name ];
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param 
		 */
		public function destroy() : void {
			_xmlLoader.removeEventListener(LoadEvent.LOADED_XML, onXmlLoaded);

			_DataProviderGroup = null;
			_xmlLoader = null;
			_DataProvider = null;
			_DataProviderGroup = null;
			_multiXmlFileFlag = undefined;
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
		 * @method parseXML( )
		 */
		private function _parseXML(xml : XML) : void {
			var node : XML;
			var nodes : XMLList;

			if ( _multiXmlFileFlag ) {
				// --------------------------------------------
				// Parse file with group of DataProviders
				// --------------------------------------------

				_DataProviderGroup = new Object;
				nodes = xml.*;

				// iterate through GROUPS
				for each ( node in nodes ) {
					var group : String = node.name();
					var contentNodes : XMLList = node.children();
					var dp : ArrayCollection = new ArrayCollection();

					// iterate through RECORDS
					for each ( var content:XML in contentNodes ) {
						var data : XMLList = content.children();
						var record : Object = ( _customDataClass != null ) ? new _customDataClass() : new Object();

						// iterate through ITEMS
						for each ( var item:XML in data ) {
							record[ item.name() ] = StrUtils.convertString(String(item.text()), String(item.attribute("type")));
						}
						// end ITEMS

						dp.addItem(record);
					}
					// end RECORDS

					_DataProviderGroup[ group ] = dp;
				}
				// end GROUPS
			} else {
				// --------------------------------------------
				// Parse file with single DataProvider
				// --------------------------------------------

				_DataProvider = new ArrayCollection();
				nodes = xml.*;

				var simpleContentFlag : Boolean = true;

				for each ( node in nodes) {
					var obj : Object = ( _customDataClass != null ) ? new _customDataClass() : new Object();
					var propNodes : XMLList = node.*;

					// ADD NODES TO OBJECT
					for each (var propNode:XML in propNodes) {
						if (propNode.hasSimpleContent()) {
							if (  propNode.attribute("type") != undefined ) {
								// trace('propNode.localName()' + propNode.localName() ) ;
								obj[ propNode.localName() ] = StrUtils.convertString(propNode.toString(), propNode.attribute("type"))
							} else {
								obj[propNode.localName()] = propNode.toString();
							}
						} else {
							simpleContentFlag = false;
						}
					}

					// ADD ATTRIBUTES TO OBJECT
					var attrs : XMLList = node.attributes();

					for each (var attr:XML in attrs) {
						obj[attr.localName()] = attr.toString();
					}

					_DataProvider.addItem(obj);
				}
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
		/**
		 * @method 
		 * @tooltip
		 */
		public function get customDataClass() : Class {
			return _customDataClass;
		}

		public function set customDataClass(customDataClass : Class) : void {
			_customDataClass = customDataClass;
		}

		/**
		 * @method 
		 * @tooltip
		 */
		public function get dataProviders() : Object {
			return _DataProviderGroup;
		}

		/**
		 * @method 
		 * @tooltip
		 */
		public function get multiXmlFileFlag() : Boolean {
			return _multiXmlFileFlag;
		}

		/**
		 * @method
		 * @tooltip
		 */
		public function set multiXmlFileFlag(multiXmlFileFlag : Boolean) : void {
			_multiXmlFileFlag = multiXmlFileFlag;
		}

		/**
		 * @method data
		 * @tooltip
		 */
		public function get data() : ArrayCollection {
			return _DataProvider
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
		 * @method onXmlLoaded( event:Object )
		 * @tooltip
		 */
		private function onXmlLoaded(event : LoadEvent) : void {
			_xmlLoader.removeEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
			_parseXML(_xmlLoader.data);

			var ev : LoadEvent = new LoadEvent(LoadEvent.LOADED_DATA)
			dispatchEvent(ev);
		}
	}
}
