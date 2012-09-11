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
package com.kurst.video.tracking.video {
	import flash.geom.Rectangle;
	import flash.geom.Matrix;

	import fl.video.VideoPlayer;

	import flash.display.BitmapData;

	import fl.video.VideoEvent;
	import fl.video.FLVPlayback;

	public class VideoUtils {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _flvPlayer : FLVPlayback;
		private var _bitmapData : BitmapData;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _frameCodeHeight : int = 15;
		// Timecode - height
		private var _bits : int = 16;
		// Number of bits in timecode
		private var _yReadOffset : int = 3;
		private var _black : uint = 0;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var captureY : Number;
		private var captureX : Number;
		private var vpHeight : Number;
		private var vpWidth : Number;
		private var vp : VideoPlayer;
		private var matrix : Matrix;
		private var rect : Rectangle;
		private var bitmapWidth : int;
		private var bitmapHeight : int;
		private var bitWidth : int;
		private var frameString : String = '';

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function VideoUtils() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *
		 * set the video source to track to
		 * 
		 * @method setVideo( video : FLVPlayback ) : void 
		 * @param video : FLVPlayback
		 */
		public function setVideo(flvPlayer : FLVPlayback) : void {
			_flvPlayer = flvPlayer;
			_flvPlayer.addEventListener(VideoEvent.READY, onVideoReady, false, 0, true);
		}

		/**
		 * 
		 * get the current frame of the video ( must be binary encoded strip at bottom )
		 * 
		 * @method getFrame() : int 
		 * @param int : -1 if video is not loaded || Frame number of video
		 */
		public function getFrame() : int {
			if ( _bitmapData ) {
				_bitmapData.fillRect(_bitmapData.rect, 0x00000000);
				_bitmapData.draw(vp, matrix, null, null, rect);
				// , mt );

				frameString = '';

				// var halfBitWidth : Number = ( bitWidth / 2 );

				for ( var c : int = 0 ; c < _bits ; c++ ) {
					trace(bitmapData.getPixel(( bitWidth * c ) + ( bitWidth / 2 ), _yReadOffset));

					// frameString += ( ( bitmapData.getPixel( ( bitWidth * c ) + halfBitWidth , yReadOffset ) ) > 1052688 ) ? 0 : 1;
					// frameString += ( ( bitmapData.getPixel( ( bitWidth * c ) + halfBitWidth , yReadOffset ) ) == 0 ) ? 1 : 0;

					frameString += ( ( bitmapData.getPixel(( bitWidth * c ) + ( bitWidth / 2 ), _yReadOffset) ) == _black ) ? 1 : 0;

					bitmapData.setPixel(( bitWidth * c ) + ( bitWidth / 2 ), _yReadOffset, 0xFFFF0000);
					// DEBUG
				}
				trace('frameString: ' + frameString);
				return parseInt(frameString, 2);
			}

			return -1;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * get the tracking code bitmapdata
		 * 
		 * @method bitmapData : BitmapData;
		 * @return BitmapData 
		 */
		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}

		/**
		 * 
		 * 
		 * 
		 * @method 
		 * @return BitmapData 
		 */
		public function get frameCodeHeight() : int {
			return _frameCodeHeight;
		}

		public function set frameCodeHeight(frameCodeHeight : int) : void {
			_frameCodeHeight = frameCodeHeight;
		}

		/**
		 * 
		 * 
		 * 
		 * @method 
		 * @return BitmapData 
		 */
		public function get bits() : int {
			return _bits;
		}

		public function set bits(bits : int) : void {
			_bits = bits;
		}

		/**
		 * 
		 * 
		 * 
		 * @method 
		 * @return BitmapData 
		 */
		public function get yReadOffset() : int {
			return _yReadOffset;
		}

		public function set yReadOffset(yReadOffset : int) : void {
			_yReadOffset = yReadOffset;
		}

		/**
		 * 
		 * 
		 * 
		 * @method 
		 * @return BitmapData 
		 */
		public function get black() : uint {
			return _black;
		}

		public function set black(black : uint) : void {
			_black = black;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * video ready event handler - initialise the video utils 
		 * 
		 */
		private function onVideoReady(event : VideoEvent) : void {
			vp = _flvPlayer.getVideoPlayer(_flvPlayer.activeVideoPlayerIndex);

			bitmapWidth = vp.width / vp.scaleX;
			bitmapHeight = Math.floor(_frameCodeHeight / vp.scaleY);
			// vp.height / vp.scaleY;

			vpHeight = vp.height / vp.scaleY;
			vpWidth = vp.width / vp.scaleX;

			captureX = 0;
			captureY = ( vp.height / vp.scaleY ) - bitmapHeight;

			_bitmapData = new BitmapData(bitmapWidth, bitmapHeight, false, 0xFF00FF00);

			rect = new Rectangle(0, 0, _bitmapData.width, _bitmapData.height);

			matrix = new Matrix();
			matrix.translate(-1 * captureX, -1 * captureY);

			bitWidth = bitmapWidth / _bits;
		}
	}
}