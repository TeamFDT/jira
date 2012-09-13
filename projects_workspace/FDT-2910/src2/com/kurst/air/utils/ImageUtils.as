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
package com.kurst.air.utils {
	import com.kurst.utils.MovieUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ImageUtils {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public static var _inst : ImageUtils;

		// private static var imageInfo : ImageInfo = new ImageInfo();
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -STATIC -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function resizeBitmap(originalBitmap : Bitmap, scaleFactor : Number) : BitmapData {
			return MovieUtils.resizeBitmap(originalBitmap, scaleFactor);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function readPNGDim(f : File) : Object {
			// trace('readPNGDim: ' + f.name );

			var ba : ByteArray = new ByteArray();
			var stream : FileStream = new FileStream();

			stream.open(f, FileMode.READ);
			stream.readBytes(ba);
			stream.close();

			var result : Object = ImageUtils.parsePNG(ba);

			ba.clear()
			stream = null;
			ba = null;

			return result;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function readJPGDim(f : File) : Object {
			// trace('readJPGDim: ' + f.name );

			var ba : ByteArray = new ByteArray();
			var stream : FileStream = new FileStream();

			stream.open(f, FileMode.READ);
			stream.readBytes(ba);
			stream.close();

			// imageInfo.checkType( ba );
			// trace( 'w: ' + imageInfo.width + ' h: ' + imageInfo.height );

			var result : Object = parseJPG(ba);

			ba.clear()
			stream = null;
			ba = null;

			return result;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private static function parsePNG(data : ByteArray) : Object {
			var start : Number = data.readUnsignedByte();
			var result : Object = new Object();

			if ( start == 137 ) {
				data.position = 16;
				result.width = data.readUnsignedInt();
				result.height = data.readUnsignedInt();

				return result;
			} else {
				result = -1;
			}

			return -1;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private static function parseJPG(data : ByteArray) : Object {
			if (data.length < 4) return null;

			data.endian = Endian.BIG_ENDIAN;
			data.position = 0;

			var magic : uint;
			var marker : uint;
			var length : uint;
			// var w	 	: uint;
			// var h	 	: uint;
			var result : Object = new Object();
			result.readError = false;

			magic = data.readUnsignedShort();
			marker = data.readUnsignedShort();

			if (magic != 0xFFD8) {
				return null;
			}

			// data.position = 0;

			while ( data.position < data.length - 1 ) {
				if ( marker == 0xFFC0 ) {
					data.position += 3;
					result.width = data.readUnsignedShort();
					result.height = data.readUnsignedShort();

					return result;
				} else {
					length = data.readUnsignedShort() - 2;

					if ( data.position + length < data.length ) {
						data.position += length;
						marker = data.readUnsignedShort();
					} else {
						result.readError = true;
						return result;
					}
				}
			}

			return -1;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}



