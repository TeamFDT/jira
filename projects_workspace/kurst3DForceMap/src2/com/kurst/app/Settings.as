/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
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
package com.kurst.app {
	import com.kurst.events.LoadEvent;
	import com.kurst.events.eventDispatcher;
	import com.kurst.loading.XmlLoader;
	import com.kurst.utils.StrUtils;

	public class Settings extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static var _inst : Settings;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function loadSettings(uri : String) : Settings {
			getInstance()._loadSettings(uri);
			return getInstance();
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getSetting(key : String) : * {
			return getInstance()._getSetting(key);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function addSetting(value : *, key : String) : void {
			getInstance()._addSetting(value, key);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function enumerate(traceFlag : Boolean = false) : void {
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getInstance() : Settings {
			if ( _inst == null )
				_inst = new Settings();
			return _inst;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		private var _xmlLoader : XmlLoader;
		private var _data : Object;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		public function Settings() {
			_data = new Object();

			_xmlLoader = new XmlLoader();
			_xmlLoader.addEventListener(LoadEvent.LOADED_XML, OnXmlLoaded, false, 0, true);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function _loadSettings(uri : String) : void {
			_xmlLoader.load(uri);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function _getSetting(key : String) : * {
			if ( _data[key] == null ) {
				trace('com.kurst.app.Settings [KEY NOT FOUND]: ' + key);
				return null;
			}

			return _data[key];
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function _addSetting(value : *, key : String) : void {
			_data[key] = value;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function _enumerate(traceFlag : Boolean = false) : void {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function parseXml(xml : XML) : void {
			var nodes : XMLList = xml.*;
			// var simpleContentFlag:Boolean	= true;

			for each (var node:XML in nodes) {
				if ( node.attribute("type") != undefined ) {
					_data[ node.localName() ] = StrUtils.convertString(node.toString(), node.attribute("type"));
				} else {
					_data[ node.localName() ] = node.toString();
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		private function OnXmlLoaded(event : LoadEvent) : void {
			parseXml(_xmlLoader.data);
			dispatchEvent(new LoadEvent(LoadEvent.LOADED_SETTINGS, false));

			_xmlLoader.clean();
		}
	
	}
}