/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: 
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
package com.kurst.data {
	import com.kurst.data.items.SimpleRssDataItem;
	import com.kurst.events.LoadEvent;
	import com.kurst.events.eventDispatcher;
	import com.kurst.loading.XmlLoader;
	import com.kurst.utils.StrUtils;

	public class SimpleRSS extends eventDispatcher {
		private var _xmlLoader : XmlLoader;
		private var _title : String
		private var _link : String
		private var _description : String
		private var _docs : String
		private var _generator : String
		private var __data : Vector.<SimpleRssDataItem>;

		function SimpleRSS() {
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
		 * @param
		 * @return
		 */
		public function load(URI : String) : void {
			_xmlLoader = new XmlLoader();
			_xmlLoader.addEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
			_xmlLoader.addEventListener(LoadEvent.XML_LOAD_ERROR, onXmlLoadError);
			_xmlLoader.load(URI);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function clean() : void {
			_xmlLoader.removeEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
			_xmlLoader.clean();
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
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function _parseXML(xml : XML) : void {
			var nodes : XMLList = xml.*;

			__data = new Vector.<SimpleRssDataItem>();
			_title = nodes.title.toString()
			_link = nodes.link.toString()
			_description = nodes.description.toString()
			_docs = nodes.docs.toString()
			_generator = nodes.generator.toString()

			for each (var node:XML in nodes) {
				var propNodes : XMLList = node.*;

				for each (var propNode:XML in propNodes) {
					if ( !propNode.hasSimpleContent()) {
						var obj : SimpleRssDataItem = new SimpleRssDataItem();

						obj.title = String(propNode[0].title);
						obj.link = String(propNode[0].link)
						obj.description = StrUtils.trim(StrUtils.stripTags(propNode[0].description));
						obj.pubDate = String(propNode[0].pubDate);

						__data.push(obj);
					}
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
		 * @param
		 * @return
		 */
		public function get data() : Vector.<SimpleRssDataItem> {
			return __data
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get title() : String {
			return _title
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get link() : String {
			return _link
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get description() : String {
			return _description
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get docs() : String {
			return _docs
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get generator() : String {
			return _generator
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
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function onXmlLoaded(event : Object) : void {
			_parseXML(_xmlLoader.data);

			var ev : LoadEvent = new LoadEvent(LoadEvent.LOADED_DATA);
			dispatchEvent(ev);

			clean();
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function onXmlLoadError(event : LoadEvent) : void {
			var ev : LoadEvent = new LoadEvent(LoadEvent.LOAD_DATA_ERROR);
			dispatchEvent(ev);
		}
	}
}