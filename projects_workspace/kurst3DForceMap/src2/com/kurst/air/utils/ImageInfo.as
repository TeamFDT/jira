package com.kurst.air.utils {
	import flash.utils.ByteArray;

	/**
	 * ImageInfo.as
	 * 
	 * 2/17/2008 10:37 AM
	 * 
	 * Retries metadata from .png, .jpg, and .gif files.
	 * 
	 * Based on java class, ImageInfo.java, by Marco Schmidt
	 * (http://schmidt.devlib.org/image-info/)
	 * 
	 * @author    Devon O.
	 * @version   .1
	 * 
	 */
	public class ImageInfo {
		private var _stream : ByteArray;
		// image properties
		private var _width : int;
		private var _height : int;
		private var _bitsPerPixel : int;
		private var _progressive : Boolean;
		private var _physicalWidth : String;
		private var _physicalHeight : String;
		private var _physicalHeightDpi : int;
		private var _physicalWidthDpi : int;
		// private var _fileType:String;
		// private var _mimeType:String;
		//
		private var _format : int;
		private const FILE_TYPES : Array = ["JPEG", "GIF", "PNG"];
		private const MIME_TYPES : Array = ["image/jpeg", "image/gif", "image/png"];
		private const FORMAT_JPEG : int = 0;
		private const FORMAT_GIF : int = 1;
		private const FORMAT_PNG : int = 2;

		/**
		 * ImageInfo checks an URLStream to see if it is a valid image file.
		 * If it is, information from the file's metadata can be retrieved from the ImageInfo instance.
		 * 
		 * @example Typical usage:
		 * <listing version="3.0">
		 *    package {
		 *
		 *      import com.onebyonedesign.utils.ImageInfo;
		 *      import flash.display.Sprite;
		 *      import flash.events.Event;
		 *      import flash.net.URLRequest;
		 *      import flash.net.URLStream;
		 *       import flash.utils.ByteArray;
		 *
		 *      public class Test extends Sprite {
		 *
		 *         private var request = new URLRequest("someImage.jpg");
		 *
		 *         public function Test():void {
		 *            var imageStream:URLStream = new URLStream();
		 *            imageStream.addEventListener(Event.COMPLETE, onImageLoad);
		 *            imageStream.load(request);
		 *         }
		 *
		 *         private function onImageLoad(e:Event):void {
		 *            var stream:URLStream = e.currentTarget as URLStream;
		 *             var ba:ByteArray = new ByteArray();
		 *             stream.readBytes(ba);
		 *            var info:ImageInfo = new ImageInfo();
		 *            if (info.checkType(ba)) {
		 *               trace ("file = " + request.url);
		 *               trace ("horizontal DPI = " + info.physicalWidthDpi);
		 *               trace ("vertical DPI = " + info.physicalHeightDpi);
		 *               trace ("pixel width = " + info.width);
		 *               trace ("pixel height = " + info.height);
		 *               trace ("bit depth = " + info.bitsPerPixel);
		 *               trace ("progressive image = " + info.progressive);
		 *               trace ("actual width = " + info.physicalWidth + " cm.");
		 *               trace ("actual height = " + info.physicalHeight + " cm.");
		 *               trace ("file type = " + info.fileType);
		 *               trace ("mime type = " + info.mimeType);
		 *            } else {
		 *               trace (request.url + " is not a valid image file.");
		 *            }
		 *         }
		 *      }
		 *   }
		 * </listing>
		 * 
		 * Typical Output:
		 * 
		 *    file = someImage.jpg
		 *   horizontal DPI = 240
		 *   vertical DPI = 240
		 *   pixel width = 480
		 *   pixel height = 640
		 *   bit depth = 24
		 *   progressive image = false
		 *   actual width = 5.08 cm.
		 *   actual height = 6.77 cm.
		 *   file type = JPEG
		 *   mime type = image/jpeg
		 */
		public function ImageInfo() : void {
		};

		/**
		 * 
		 * @param   ByteArray of image file
		 * @return   True for valid .jpg, .png, and .gif images - false otherwise.
		 */
		public function checkType(bytes : ByteArray) : Boolean {
			_stream = bytes;

			var b1 : int = read() & 0xFF;
			var b2 : int = read() & 0xFF;

			if (b1 == 0x47 && b2 == 0x49) {
				return checkGif();
			}

			if (b1 == 0xFF && b2 == 0xD8) {
				return checkJPG();
			}

			if (b1 == 0x89 && b2 == 0x50) {
				return checkPng();
			}

			return false;
		}

		private function checkGif() : Boolean {
			var GIF_MAGIC_87A : ByteArray = new ByteArray()
			GIF_MAGIC_87A.writeByte(0x46);
			GIF_MAGIC_87A.writeByte(0x38);
			GIF_MAGIC_87A.writeByte(0x37);
			GIF_MAGIC_87A.writeByte(0x61);

			var GIF_MAGIC_89A : ByteArray = new ByteArray();
			GIF_MAGIC_89A.writeByte(0x46);
			GIF_MAGIC_89A.writeByte(0x38);
			GIF_MAGIC_89A.writeByte(0x39);
			GIF_MAGIC_89A.writeByte(0x61);

			var a : ByteArray = new ByteArray();
			if (read(a, 0, 11) != 11) {
				return false;
			}

			if ((!equals(a, 0, GIF_MAGIC_89A, 0, 4)) && (!equals(a, 0, GIF_MAGIC_87A, 0, 4))) {
				return false;
			}

			_format = FORMAT_GIF;
			_width = getShortLittleEndian(a, 4);
			_height = getShortLittleEndian(a, 6);
			var flags : int = a[8] & 0xFF;
			_bitsPerPixel = ((flags >> 4) & 0x07) + 1;
			_progressive = (flags & 0x02) != 0;

			return true;
		}

		private function checkPng() : Boolean {
			var PNG_MAGIC : ByteArray = new ByteArray();
			PNG_MAGIC.writeByte(0x4E);
			PNG_MAGIC.writeByte(0x47);
			PNG_MAGIC.writeByte(0x0D);
			PNG_MAGIC.writeByte(0x0A);
			PNG_MAGIC.writeByte(0x1A);
			PNG_MAGIC.writeByte(0x0A);

			var a : ByteArray = new ByteArray();
			if (read(a, 0, 27) != 27) {
				return false;
			}

			if (!equals(a, 0, PNG_MAGIC, 0, 6)) {
				return false;
			}

			_format = FORMAT_PNG;
			_width = getIntBigEndian(a, 14);
			_height = getIntBigEndian(a, 18);
			_bitsPerPixel = a[22];
			var colorType : int = a[23];
			if (colorType == 2 || colorType == 6) {
				_bitsPerPixel *= 3;
			}
			_progressive = (a[26]) != 0;
			return true;
		}

		private function checkJPG() : Boolean {
			var  APP0_ID : ByteArray = new ByteArray();
			APP0_ID.writeByte(0x4A);
			APP0_ID.writeByte(0x46);
			APP0_ID.writeByte(0x49);
			APP0_ID.writeByte(0x46);
			APP0_ID.writeByte(0x00);

			var data : ByteArray = new ByteArray();
			while (true) {
				if (read(data, 0, 4) != 4) {
					return false;
				}

				var marker : Number = getShortBigEndian(data, 0);
				var size : Number = getShortBigEndian(data, 2);

				if ((marker & 0xff00) != 0xff00) {
					return false;
				}

				if (marker == 0xFFE0) {
					if (size < 14) {
						skip(size - 2);
						continue;
					}

					if (read(data, 0, 12) != 12) {
						return false;
					}

					if (equals(APP0_ID, 0, data, 0, 5)) {
						if (data[7] == 1) {
							setPhysicalWidthDpi(getShortBigEndian(data, 8));
							setPhysicalHeightDpi(getShortBigEndian(data, 10));
						} else if (data[7] == 2) {
							var x : int = getShortBigEndian(data, 8);
							var y : int = getShortBigEndian(data, 10);

							setPhysicalWidthDpi(int(x * 2.54));
							setPhysicalHeightDpi(int(y * 2.54));
						}
					}
					skip(size - 14);
				} else if (marker >= 0xFFC0 && marker <= 0xFFCF && marker != 0xFFC4 && marker != 0xFFC8) {
					if (read(data, 0, 6) != 6) {
						return false;
					}

					_format = FORMAT_JPEG;
					_bitsPerPixel = (data[0] & 0xFF) * (data[5] & 0xFF);
					_progressive = marker == 0xffc2 || marker == 0xffc6 || marker == 0xffca || marker == 0xffce;
					_width = getShortBigEndian(data, 3);
					_height = getShortBigEndian(data, 1);
					var horzPixelsPerCM : Number = _physicalWidthDpi / 2.54;
					var vertPixelsPerCM : Number = _physicalHeightDpi / 2.54
					_physicalWidth = (_width / horzPixelsPerCM).toFixed(2);
					_physicalHeight = (_height / vertPixelsPerCM).toFixed(2);

					return true;
				} else {
					skip(size - 2);
				}
			}
			return false;
		}

		private function getShortBigEndian(ba : ByteArray, offset : int) : Number {
			return ba[offset] << 8 | ba[offset + 1];
		}

		private function getShortLittleEndian(ba : ByteArray, offset : int) : int {
			return ba[offset] | ba[offset + 1] << 8;
		}

		private function getIntBigEndian(ba : ByteArray, offset : int) : int {
			return ba[offset] << 24 | ba[offset + 1] << 16 | ba[offset + 2] << 8 | ba[offset + 3];
		}

		private function skip(numBytes : int) : void {
			_stream.position += numBytes;
		}

		private function equals(ba1 : ByteArray, offs1 : int, ba2 : ByteArray, offs2 : int, num : int) : Boolean {
			while (num-- > 0) {
				if (ba1[offs1++] != ba2[offs2++]) {
					return false;
				}
			}
			return true;
		}

		private function read(... args) : int {
			switch (args.length) {
				case 0    :
					return _stream.readByte();
					break;
				case 1    :
					_stream.readBytes(args[0]);
					return args[0].length;
					break;
				case 3    :
					_stream.readBytes(args[0], args[1], args[2]);
					return args[2];
					break;
				default :
					throw new ArgumentError("Argument Error at ImageInfo.read(). Expected 0, 1, or 3. Received " + args.length);
					return null;
			}
		}

		private function setPhysicalHeightDpi(newValue : int) : void {
			_physicalWidthDpi = newValue;
		}

		private function setPhysicalWidthDpi(newValue : int) : void {
			_physicalHeightDpi = newValue;
		}

		// Read Only Properties of image
		// vertical and horizontal DPI
		public function get physicalHeightDpi() : int {
			return _physicalHeightDpi;
		}

		public function get physicalWidthDpi() : int {
			return _physicalWidthDpi;
		}

		// bit depth
		public function get bitsPerPixel() : int {
			return _bitsPerPixel;
		}

		// width and height in pixels
		public function get height() : int {
			return _height;
		}

		public function get width() : int {
			return _width;
		}

		// progressive or not
		public function get progressive() : Boolean {
			return _progressive;
		}

		// file and mimetype
		public function get fileType() : String {
			return FILE_TYPES[_format];
		}

		public function get mimeType() : String {
			return MIME_TYPES[_format];
		}

		// height and width in centimeters
		public function get physicalWidth() : String {
			return _physicalWidth;
		}

		public function get physicalHeight() : String {
			return _physicalHeight;
		}
	}
}