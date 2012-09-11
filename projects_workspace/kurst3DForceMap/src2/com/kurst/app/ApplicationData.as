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
	import com.kurst.events.eventDispatcher;

	import flash.net.SharedObject;

	public class ApplicationData extends eventDispatcher {
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-STATIC -----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static const SAVED_DATA_SO_NAME : String = 'ApplicationSavedData'
		private static var savedUserSettings : SharedObject;

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function saveSetting(key : String, value : *) : void {
			ApplicationData.initSharedObject();
			ApplicationData.savedUserSettings.data[key] = value;

			Settings.addSetting(value, key);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getSetting(key : String) : * {
			ApplicationData.initSharedObject();
			return ApplicationData.savedUserSettings.data[key];
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function addDefaultSetting(key : String, value : *) : void {
			
			ApplicationData.initSharedObject();

			if ( ApplicationData.savedUserSettings.data[key] == null ) {
				
				ApplicationData.saveSetting(key, value);
				
			} else {
				
				Settings.addSetting(value, key);
				
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE ---------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private static function initSharedObject() : void {
			
			if ( ApplicationData.savedUserSettings == null ) {
				
				ApplicationData.savedUserSettings = SharedObject.getLocal(ApplicationData.SAVED_DATA_SO_NAME);

				for ( var i : String in ApplicationData.savedUserSettings.data )
					Settings.addSetting(ApplicationData.savedUserSettings.data[i], i);
					
			}
		}
	}
}
