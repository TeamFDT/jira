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
	import com.kurst.data.items.PixelpostGalleryItem;
	import com.kurst.events.CEventDispatcher;
	import com.kurst.events.LoadEvent;
	import com.kurst.loading.XmlLoader;
	import com.kurst.utils.DateUtils;
	import com.kurst.utils.StrUtils;

	import mx.collections.ArrayCollection;

	public class Pixelpost extends CEventDispatcher {
		private var _xmlLoader : XmlLoader;
		private var __imageFolder : String = "images"
		private var __thumbFolder : String = "thumbnails"
		private var __thumbprefix : String = "thumb_"
		private var __rootURL : String = ""
		private var _title : String
		private var _link : String
		private var _description : String
		private var _docs : String
		private var _generator : String
		private var __data : ArrayCollection;
		private var _itemCounter : int;
		private var _useRelativePath : Boolean = true

		function Pixelpost() {
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
		 * @method getItemAt( p : int ) : PixelpostGalleryItem
		 * @tooltip
		 * @param
		 * @return
		 */
		public function getItemAt(p : int) : PixelpostGalleryItem {
			return __data.getItemAt(p)  as PixelpostGalleryItem;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function load(URI : String) : void {
			_itemCounter = 0;
			_xmlLoader = new XmlLoader();
			_xmlLoader.addEventListener(LoadEvent.LOADED_XML, onXmlLoaded);
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
			__data = new ArrayCollection();

			var nodes : XMLList = xml.*;

			_title = nodes.title.toString()
			_link = nodes.link.toString()
			_description = nodes.description.toString()
			_docs = nodes.docs.toString()
			_generator = nodes.generator.toString()

			for each (var node:XML in nodes) {
				var propNodes : XMLList = node.*;

				// ADD NODES TO OBJECT
				for each (var propNode:XML in propNodes) {
					if ( !propNode.hasSimpleContent()) {
						var obj : PixelpostGalleryItem = new PixelpostGalleryItem();

						obj.title = propNode[0].title;
						obj.link = propNode[0].link;
						obj.description = StrUtils.trim(StrUtils.stripTags(propNode[0].description));
						obj.shortdescription = propNode[0].shortdescription
						obj.pubDate = propNode[0].pubDate;
						obj.thumb = parseThumbnail(propNode[0].description);
						obj.image = parseImage(propNode[0].description);
						obj.date = DateUtils.convertPixelPostDate(obj.pubDate);
						obj.id = _itemCounter;
						obj.uri = propNode[0].uri;
						obj.group = propNode[0].group;

						__data.addItem(obj);

						_itemCounter++
					}
				}
			}
		}

		/**
		 * getUrlFromDescription
		 * 
		 * @usage   
		 * @param   str 
		 * @return  
		 */
		private function getUrlFromDescription(str : String) : String {
			var strPrefix : String = "http"
			var strEnd : String = ".jpg"

			// var return_str:String 		= ""

			if ( str == null ) return "";

			var s : Number = str.indexOf(strPrefix)
			// start
			var e : Number = str.indexOf(strEnd, s) + strEnd.length
			// end

			return ( str.slice(s, e) );
		}

		/**
		 * parseImage
		 * 
		 * @usage   
		 * @param   str 
		 * @return  
		 */
		private function parseImage(str : String) : String {
			var thumbPath : String = getUrlFromDescription(str);
			var imagePath : String = StrUtils.replaceChar(thumbPath, __thumbFolder, __imageFolder);
			imagePath = StrUtils.replaceChar(imagePath, __thumbprefix, "");

			if ( _useRelativePath )
				imagePath = StrUtils.replaceChar(imagePath, __rootURL, "");

			return imagePath
		}

		/**
		 * parseThumbnail
		 * 
		 * @usage   
		 * @param   str 
		 * @return  
		 */
		private function parseThumbnail(str : String) : String {
			var thumbPath : String = getUrlFromDescription(str);

			if ( _useRelativePath )
				thumbPath = StrUtils.replaceChar(thumbPath, __rootURL, "");

			return thumbPath;
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
		public function get length() : int {
			return __data.length
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function get data() : ArrayCollection {
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

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function set uri(s : String) : void {
			__rootURL = s
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

			var ev : LoadEvent = new LoadEvent(LoadEvent.LOADED_PIXELPOST_DATA);
			dispatchEvent(ev);

			clean();
		}
	}
}