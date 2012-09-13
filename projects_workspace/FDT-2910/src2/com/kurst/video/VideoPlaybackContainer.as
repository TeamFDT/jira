/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.VideoPlaybackContainer
 * Version 	  	: 1
 * Description 	: container for FLVPlayback - mask timecode for tracked videos
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 08 / 11 / 11
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	setSize( w : Number , h : Number ) : void 
 *
 * PROPERTIES
 * 
 * 	get player() 		: FLVPlayback 
 * 	get / set width() 	: Number
 * 	get / set height() 	: Number 
 * 
 ********************************************************************************************************************************************************************************
 *
 **********************************************************************************************************************************************************************************/
package com.kurst.video {
	import fl.video.VideoScaleMode;

	import flash.geom.Rectangle;

	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	import fl.video.FLVPlayback;

	import flash.display.Sprite;

	public class VideoPlaybackContainer extends Sprite {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _player : FLVPlayback;
		private var _width : Number = 540
		private var _height : Number = 420;
		private var _scrollRect : Rectangle;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function VideoPlaybackContainer() {
			// cacheAsBitmap = true;
			addChild(_player = new FLVPlayback()) ;

			_player.addEventListener(VideoEvent.READY, onVideoReady, false, 0, true);
			_player.addEventListener(MetadataEvent.METADATA_RECEIVED, onMetaDataLoaded, false, 0, true);

			_player.fullScreenTakeOver = false;
			_player.registrationX = _player.registrationY = 0;
			_player.x = _player.y = 0;
			_player.scaleMode = VideoScaleMode.NO_SCALE;

			_scrollRect = new Rectangle(0, 0, _width, _height) ;

			resize();
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
		public function setSize(w : Number, h : Number) : void {
			_width = w;
			_height = h;

			resize();
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
		private function resize() : void {
			_player.width = _width;
			_player.height = _height;

			_player.setSize(_width, _height);

			_scrollRect.width = _width;
			_scrollRect.height = _height;

			scrollRect = _scrollRect;
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
		public function get player() : FLVPlayback {
			return _player;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get width() : Number {
			return _width;
		}

		override public function set width(width : Number) : void {
			_width = width;
			resize();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get height() : Number {
			return _height;
		}

		override public function set height(height : Number) : void {
			_height = height;
			resize();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onMetaDataLoaded(event : MetadataEvent) : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onVideoReady(event : VideoEvent) : void {
		}
	}
}