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
package com.kurst.visuals.view {
	import com.kurst.utils.MovieUtils;
	import com.kurst.visuals.assets.AssetManager;
	import com.kurst.visuals.core.AbstractComp;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;

	public class OutputView extends Sprite {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Output View States
		public static const COMP_STOPPED : uint = 0;
		public static const COMP_QUEUED : uint = 1;
		public static const COMP_PLAYING : uint = 2;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _background : Sprite;
		private var activeComp : AbstractComp;
		private var assetManager : AssetManager;
		private var _state : uint = OutputView.COMP_STOPPED;
		private var _backgroundColour : int = 0x000000;
		// AppSettings.OUTPUT_BACKGROUND;
		private var _visualsWidth : Number = 640;
		private var _visualsHeight : Number = 480;
		private var _useMicrophone : Boolean = true;
		private var _scaleToStage : Boolean = true;
		private var _windowWidth : Number
		private var _windowHeight : Number

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function OutputView(_assetManager : AssetManager) {
			assetManager = _assetManager;
			_background = new Sprite();

			addChild(_background)

			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * start a visual composition. 
		 *  
		 * 
		 * @param comp 			: Class - must extend AbstractComp
		 * @param audioStart 	: Boolean - automatically start the visuals composition 
		 */
		public function startVisualComp(comp : Class, autoStart : Boolean = true) : void {
			if ( comp == null ) return;
			if ( isCompPlaying ) return;

			if ( activeComp != null ) {
				activeComp.destroy();
				activeComp = null;
			}

			activeComp = new comp(_visualsWidth, _visualsHeight) as AbstractComp;

			activeComp.useMicrophone = _useMicrophone;
			activeComp.setAssets(assetManager.getAssets());

			if ( activeComp != null )
				addChild(activeComp);

			if ( autoStart )
				playComp();

			resizeStage();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function stopVisualComp() : void {
			if ( activeComp != null ) {
				activeComp.stopVisuals();
				activeComp.destroy();
				removeChild(activeComp)

				activeComp = null;
				_state = OutputView.COMP_STOPPED;
			}

			System.gc();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function callCompFunction(functionName : String) : void {
			if ( activeComp != null ) {
				if ( MovieUtils.functionExists(activeComp, functionName) )
					activeComp[ functionName ]();
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function queueComp(compID : Class) : AbstractComp {
			_state = OutputView.COMP_QUEUED
			startVisualComp(compID, false)
			return activeComp;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function playComp() : void {
			if ( activeComp != null ) {
				if ( !isCompPlaying )
					activeComp.startVisuals();

				_state = OutputView.COMP_PLAYING
			}

			resizeStage();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function draw() : void {
			if ( stage != null && _scaleToStage ) {
				_background.graphics.beginFill(_backgroundColour)
				_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_background.graphics.endFill();
			} else if ( stage != null && !_scaleToStage ) {
				_background.graphics.beginFill(_backgroundColour)
				_background.graphics.drawRect(0, 0, compWidth, compHeight);
				_background.graphics.endFill();
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// STATE
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getState() : uint {
			return _state
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getActiveComp() : AbstractComp {
			return activeComp;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get isCompPlaying() : Boolean {
			return ( _state == OutputView.COMP_PLAYING );
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get isCompQueued() : Boolean {
			return ( _state == OutputView.COMP_QUEUED );
		}

		// PROPERTIES
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get compWidth() : Number {
			return _visualsWidth;
		}

		public function set compWidth(visualsWidth : Number) : void {
			_visualsWidth = visualsWidth;
			resizeStage();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get compHeight() : Number {
			return _visualsHeight;
		}

		public function set compHeight(visualsHeight : Number) : void {
			_visualsHeight = visualsHeight;
			resizeStage();
		}

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
			draw();
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

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get scaleToStage() : Boolean {
			return _scaleToStage;
		}

		public function set scaleToStage(scaleToStage : Boolean) : void {
			_scaleToStage = scaleToStage;
		}

		public function get background() : Sprite {
			return _background;
		}

		public function set background(background : Sprite) : void {
			_background = background;
		}

		public function get windowWidth() : Number {
			return _windowWidth;
		}

		public function set windowWidth(windowWidth : Number) : void {
			_windowWidth = windowWidth;
		}

		public function get windowHeight() : Number {
			return _windowHeight;
		}

		public function set windowHeight(windowHeight : Number) : void {
			_windowHeight = windowHeight;
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
		private function addedToStage(event : Event) : void {
			stage.addEventListener(Event.RESIZE, resizeStage, false, 0, true);
			// stage.quality 		= StageQuality.LOW;
			resizeStage();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function resizeStage(event : Event = null) : void {
			draw();

			if ( activeComp != null && _scaleToStage )
				activeComp.resize(stage.stageWidth, stage.stageHeight);
		}
	}
}