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
package com.kurst.visuals.core {
	import com.kurst.utils.MovieUtils;
	import com.kurst.visuals.audio.SpectrumMicReader;
	import com.kurst.visuals.data.AssetVo;

	import flash.display.Sprite;

	/**
	 * @author karim
	 */
	public class AbstractComp extends Sprite implements IComp {
		// public static var useMic		: Boolean = true;
		/*
		[Embed(source="../../../../../assets/stage.jpg")]
		private var backgroundImage 	: Class;
		private var backgroundBitmap 	: Bitmap;
		 */
		// private var stageBounds 		: Sprite = new Sprite();
		private var _background : Sprite;
		// Properties
		private var _backgroundColour : int = 0x000000;
		private var _compName : String = '';
		private var _id : String = '';
		private var _useMicrophone : Boolean = true;
		private var _compWidth : Number;
		private var _compHeight : Number;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function AbstractComp(width : Number = 640, height : Number = 480) {
			super();

			_compWidth = width;
			_compHeight = height;

			_background = new Sprite();

			addChild(_background)
			drawBackground();

			/*
			if ( AppSettings.SHOW_STAGE_LAYOUT ){

			backgroundBitmap = new backgroundImage();
			addChild( backgroundBitmap )
								
			}
			 * 
			 */
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
		public function destroy() : void {
			/*
			if ( backgroundBitmap != null ){
				
			if ( contains( backgroundBitmap )){
			removeChild( backgroundBitmap )
			backgroundBitmap = null;
			}
				
			}
			 */
			if ( _background != null ) {
				if ( contains(_background)) {
					removeChild(_background)
					_background = null;
				}
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function startVisuals() : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function stopVisuals() : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function setAssets(assets : Vector.<AssetVo> = null) : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function resize(stageWidth : int, stageHeight : int) : void {
			MovieUtils.porportionalScaleTo(_background, 0, stage.stageWidth, 0, stage.stageHeight)
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getSpectrumReader(size : int, spectrumLength : Number = 512) : SpectrumMicReader {
			var sm : SpectrumMicReader

			if ( useMicrophone ) {
				sm = new SpectrumMicReader(size, spectrumLength)
				sm.enableMicrophone(true);
			} else {
				sm = new SpectrumMicReader(size)
				sm.multiplier = 8;
			}

			return sm;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function drawBackground() : void {
			if ( _background != null ) {
				_background.graphics.clear();
				_background.graphics.beginFill(_backgroundColour);
				_background.graphics.drawRect(0, 0, _compWidth, _compHeight);
				_background.graphics.endFill();
			}
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
		public function get backgroundColour() : int {
			return _backgroundColour;
		}

		public function set backgroundColour(backgroundColour : int) : void {
			_backgroundColour = backgroundColour;
			drawBackground();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get compName() : String {
			return _compName;
		}

		public function set compName(compName : String) : void {
			_compName = compName;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get id() : String {
			return _id;
		}

		public function set id(id : String) : void {
			_id = id;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get compWidth() : Number {
			return _compWidth;
		}

		public function set compWidth(compWidth : Number) : void {
			_compWidth = compWidth;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get compHeight() : Number {
			return _compHeight;
		}

		public function set compHeight(compHeight : Number) : void {
			_compHeight = compHeight;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get useMicrophone() : Boolean {
			return _useMicrophone;
		}

		public function set useMicrophone(useMicrophone : Boolean) : void {
			_useMicrophone = useMicrophone;
		}

		public function get background() : Sprite {
			return _background;
		}

		public function set background(background : Sprite) : void {
			_background = background;
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}