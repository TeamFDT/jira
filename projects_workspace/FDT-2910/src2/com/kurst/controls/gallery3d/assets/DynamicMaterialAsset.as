/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.gallery3d.assets.DynamicMaterialAsset
 * Version 	  	: 1
 * Description 	: DynamicMaterialAsset, can play SWF, and VideoContent as well as load Images
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 10/11/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 *
 *	 See com.kurst.controls.gallery3d.assets.CoreAsset for inherited Methods
 *	
 *	 playVideo( )
 *	 pauseVideo( )
 *
 * PROPERTIES
 * 
 * 	See com.kurst.controls.gallery3d.assets.CoreAsset for inherited Properties
 * 	
 *	container () : MovieClip 
 *	isVideoPlaying() : Boolean 	
 *
 * EVENTS
 * 
 *	See com.kurst.controls.gallery3d.assets.CoreAsset for inherited Events
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.assets {
	import com.kurst.utils.MovieUtils;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;

	// import mx.controls.videoClasses.VideoPlayer;
	// import mx.controls.VideoDisplay;
	public class DynamicMaterialAsset extends CoreAsset implements ICoreAsset {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private const THUMBNAIL_ASSET_NAME : String = 'thumbnailBitmap';
		private var _lowResScalar : Number = -1
		private var _bitmap : Bitmap;
		private var _sbitmap : Bitmap;
		private var imageContainer : MovieClip;
		private var useLowResImage : Boolean = true;
		private var _playFlag : Boolean = false;
		// private var _playFix				: Boolean = true;
		private var _largeImageContainer : Sprite;
		private var _largeImageLoader : Loader;
		private var _largeImageLoaded : Boolean = false;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function DynamicMaterialAsset() {
			super();

			imageContainer = new MovieClip()
			addChild(imageContainer)
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
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ASSET MANAGEMENT -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function addSWF(s : MovieClip) : void {
			swfFlag = true;
			swf = s;

			addChild(swf);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function addImage(bm : Bitmap) : void {
			_bitmap = bm;
			_bitmap.visible = false;

			createLoadResImage();

			if ( useThumbnail ) {
				_bitmap.bitmapData.dispose();
				_bitmap.bitmapData = null;
				_bitmap = null;
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// STATE -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function destroy() : void {
			deleteVideoPlayer();

			if ( _bitmap != null ) {
				if ( imageContainer.contains(_bitmap) ) {
					imageContainer.removeChild(_bitmap);
				}
			}

			if ( _bitmap != null ) {
				_bitmap.bitmapData.dispose();
				_bitmap.bitmapData = null;
				_bitmap = null;
			}

			if ( _sbitmap != null ) {
				if ( imageContainer.contains(_sbitmap))
					imageContainer.removeChild(_sbitmap);

				_sbitmap.bitmapData.dispose();
				_sbitmap.bitmapData = null;
				_sbitmap = null;
			}

			if ( _largeImageLoader != null ) {
				_largeImageLoader.unloadAndStop(true);
				_largeImageLoader = null;
			}

			isSelected = undefined;
			data = null;

			super.destroy();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function unSelect() : void {
			isSelected = false;

			// SWF -

			if ( swfFlag ) {
				movieMaterial.animated = false;

				if ( MovieUtils.functionExists(swf, 'deselect') ) {
					swf.deselect();

					movieMaterial.updateBitmap();
					movieMaterial.drawBitmap()
				}
			}

			// VIDEO

			if ( videoEnabled && video != null ) {
				deleteVideoPlayer();
				movieMaterial.animated = false;

				movieMaterial.updateBitmap();
				movieMaterial.drawBitmap()
			}

			//
			showHiResImage(false);

			if ( useThumbnail )
				stopLoadLargeImage()
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function selectedAnimationComplete() : void {
			if ( videoURI != null ) {
				if ( videoEnabled && videoURI.length > 1) {
					createVideoPlayer();
					movieMaterial.updateBitmap();
					movieMaterial.drawBitmap()
					movieMaterial.animated = true;
				}
			}

			if ( swfFlag ) {
				movieMaterial.animated = true;

				if ( MovieUtils.functionExists(swf, 'select') )
					swf.select();

				movieMaterial.updateBitmap();
				movieMaterial.drawBitmap()
			}
		}

		override public function select() : void {
			super.select();
			loadLargeImage();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// VIDEO -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function playVideo() : void {
			trace('data.video: ' + data.video);
			trace('stage: ' + stage);

			if ( stream == null && data.video != '' ) {
				createVideoPlayer();
			}

			if ( stream != null ) {
				stream.resume()
				_playFlag = true;
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function pauseVideo() : void {
			if ( stream != null ) {
				stream.pause();
				_playFlag = false;
			}
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
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function loadLargeImage() : void {
			if ( useThumbnail && !_largeImageLoaded ) {
				_largeImageLoaded = false;

				stopLoadLargeImage();

				var imageURI : String = data[ imageDataBinding ]

				_largeImageLoader = new Loader();
				_largeImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, largeImageLoaded, false, 0, true);
				_largeImageLoader.load(new URLRequest(imageURI));
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function largeImageLoaded(e : Event) : void {
			if ( useThumbnail ) {
				_largeImageLoaded = true;
				_largeImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, largeImageLoaded)

				_bitmap = _largeImageLoader.content as Bitmap;

				showHiResImage(true);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function stopLoadLargeImage() : void {
			if ( useThumbnail ) {
				if ( _largeImageLoader != null ) {
					showHiResImage(false);

					// _largeImageLoader.unloadAndStop( true );

					_largeImageLoaded = false;
					_largeImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, largeImageLoaded)
					_largeImageLoader.unload();
					_largeImageLoader = null;
					_bitmap = null;
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// VIDEO -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function deleteVideoPlayer() : void {
			if ( video != null )
				removeChild(video);

			_playFlag = false;

			if ( stream != null ) {
				stream.close();
				stream.pause()
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler);
				stream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
				stream.client = {};
				stream = null;
			}

			if ( connection != null )
				connection.close();

			connection = null;
			video = null;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function createVideoPlayer() : void {
			if ( video == null ) {
				var customClient : Object = new Object();
				customClient["onCuePoint"] = cuePointHandler;
				customClient["onMetaData"] = metaDataHandler;

				connection = new NetConnection();
				connection.connect(null)

				stream = new NetStream(connection)
				stream.client = customClient

				stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler);
				stream.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);

				video = new Video();
				video.smoothing = true;

				video.attachNetStream(stream);

				video.width = width
				video.height = height

				// trace('play: ' + videoURI );

				stream.play(videoURI);

				stream.seek(0);
				stream.resume();
			}

			addChild(video);
			// trace('data.autoplay: ' + data.autoplay )

			movieMaterial.animated = true;
			movieMaterial.updateBitmap();
			movieMaterial.drawBitmap()
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// UI -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function createLoadResImage() : void {
			if ( _bitmap == null ) return;

			if ( _sbitmap == null ) {
				_sbitmap = new Bitmap()
				_sbitmap.name = THUMBNAIL_ASSET_NAME;
				// 'thumbnailBitmap';

				imageContainer.addChild(_sbitmap);
			} else {
				var isOnDisplay : Boolean = _sbitmap.visible;

				if ( imageContainer.getChildByName(THUMBNAIL_ASSET_NAME) != null ) {
					imageContainer.removeChild(_sbitmap);
				}

				_sbitmap.bitmapData.dispose();
				_sbitmap.bitmapData = null;
				_sbitmap = null;

				imageContainer.graphics.clear();

				_sbitmap = new Bitmap();
				_sbitmap.name = THUMBNAIL_ASSET_NAME;
				_sbitmap.visible = isOnDisplay;
				imageContainer.addChild(_sbitmap);
			}

			_sbitmap.bitmapData = MovieUtils.resizeBitmap(_bitmap, 1 / _lowResScalar)
			_sbitmap.scaleX = _sbitmap.scaleY = _lowResScalar;

			if ( movieMaterial != null ) {
				movieMaterial.updateBitmap();
				movieMaterial.drawBitmap()
			}
		}

		/**
		 * @met hod 
		 * @tooltip
		 * @param
		 * @return
		 */
		private function showHiResImage(flag : Boolean = true) : void {
			if ( !flag ) {
				try {
					imageContainer.removeChild(_bitmap);

					_bitmap.visible = false;
					_sbitmap.visible = true;

					movieMaterial.updateBitmap();
					movieMaterial.drawBitmap()
				} catch ( e : Error ) {
				}
			} else {
				try {
					imageContainer.addChild(_bitmap);

					_bitmap.visible = true;
					_sbitmap.visible = false;

					movieMaterial.updateBitmap();
					movieMaterial.drawBitmap()
				} catch ( e : Error ) {
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
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get container() : MovieClip {
			return imageContainer;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get isVideoPlaying() : Boolean {
			return _playFlag;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get bitmap() : Bitmap {
			return _sbitmap;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get thumbQuality() : Number {
			return _lowResScalar;
		}

		override public function set thumbQuality(lrs : Number) : void {
			if ( _lowResScalar != lrs ) {
				_lowResScalar = lrs;
				createLoadResImage()
			}

			_lowResScalar = lrs;
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
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// VIDEO -----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function NetStreamPlayStop() : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onStreamStatus(event : NetStatusEvent) : void {
			switch ( event.info.code ) {
				case "NetStream.Play.Start":
					movieMaterial.animated = true;
					if ( !data.autoplay ) {
						_playFlag = false;
						stream.pause();
					} else {
						_playFlag = true;
					}
					/*
					if ( _playFix == true ) {
						
					_playFix 		= false;
					// data.autoplay 	= false;
					}*/
					break;
				case "NetStream.Unpause.Notify":
					movieMaterial.animated = true;
					_playFlag = true;
					break;
				case "NetStream.Play.Failed":
					movieMaterial.animated = false;
					_playFlag = false;
					break;
				case "NetStream.Play.Stop":
					NetStreamPlayStop();
					movieMaterial.animated = false;
					_playFlag = false;
					break;
				case "NetStream.Play.StreamNotFound":
					movieMaterial.animated = false;
					_playFlag = false;
					break;
				case "NetStream.Pause.Notify":
					movieMaterial.animated = false;
					_playFlag = false;
					break;
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function ayncErrorHandler(e : AsyncErrorEvent) : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function cuePointHandler(infoObject_ : Object) : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function metaDataHandler(infoObject_ : Object) : void {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// UI ------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function MouseRollOver() : void {
			// trace('MouseRollOver.isSelected: ' + isSelected )
			if ( !isSelected && _largeImageLoaded )
				showHiResImage(true);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function MouseRollOut() : void {
			// trace('MouseRollOut.isSelected: ' + isSelected )
			if ( !isSelected && _largeImageLoaded )
				showHiResImage(false);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function MouseDown(e : MouseEvent = null) : void {
			isSelected = true;
			showHiResImage(true);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function MouseUpEvent(e : MouseEvent = null) : void {
		}
	}
}