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
package com.kurst.air.data {
	import flash.display.BitmapData;
	import flash.filesystem.File;

	public class ImageDataItem {
		
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _ratio 			: Number;
		private var _bitmapData 	: BitmapData;
		private var _url 			: String
		private var _file 			: File;
		private var _resizeFlag 	: Boolean 	= false;
		private var _processed 		: Boolean	= false;
		private var _encodeProgress : Number 	= 0

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function ImageDataItem() { }

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getFileName() : String {
			return _file.name;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroyBitmapData() : void {
			if ( _bitmapData != null ) {
				_bitmapData.dispose();
				_bitmapData = null
			}
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			
			destroyBitmapData();

			_file 			= null;
			_url 			= null;
			_ratio 			= NaN;
			_encodeProgress = NaN;
			
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get filename() : String {
			return getFileName();
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get url() : String {
			return _url;
		}
		public function set url(value : String) : void {
			_url = value;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get ratio() : Number {
			return _ratio;
		}
		public function set ratio(value : Number) : void {
			_ratio = value;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get file() : File {
			return _file;
		}
		public function set file(file : File) : void {
			_file = file;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}
		public function set bitmapData(bitmapData : BitmapData) : void {
			_bitmapData = bitmapData;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get resize() : Boolean {
			return _resizeFlag;
		}
		public function set resize(resizeFlag : Boolean) : void {
			_resizeFlag = resizeFlag;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get processed() : Boolean {
			return _processed;
		}
		public function set processed(processed : Boolean) : void {
			_processed = processed;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get encodeProgress() : Number {
			return _encodeProgress;
		}
		public function set encodeProgress(encodeProgress : Number) : void {
			_encodeProgress = encodeProgress;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}