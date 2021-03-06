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
package com.kurst.air.utils.data {
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	public class ImageResizeData {
		private var _ratio : Number;
		private var _bitmap : Bitmap;
		private var _url : String
		private var _byteArray : ByteArray;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function ImageResizeData() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function destroy() : void {
			_bitmap.bitmapData.dispose();
			_bitmap.bitmapData = null
			_bitmap = null;

			_url = null;
			_ratio = NaN;
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
		public function get byteArray() : ByteArray {
			return _byteArray;
		}

		public function set byteArray(value : ByteArray) : void {
			_byteArray = value;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
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
		public function get bitmap() : Bitmap {
			return _bitmap;
		}

		public function set bitmap(value : Bitmap) : void {
			_bitmap = value;
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}