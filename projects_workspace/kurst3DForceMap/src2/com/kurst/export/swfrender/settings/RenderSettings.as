/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.swfrenderer.renderer.settings.RenderSettings
 * Description 	: Render Settings - all data / settings to start a render process 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	getTotalFrames() 
 * 	setAVM( _avm : String ) - AvmProps.AVM1 || AvmProps.AVM2
 * 
 *
 * PROPERTIES
 * 
 * 	AVM ( get only ) 
 * 	
 * 	frameRate : int
 * 	backgroundColour : uint
 * 	backgroundTransparent : Boolean
 * 	stopOnLastFrame : Boolean
 * 	animationSecondsToStop : Number
 * 	outputPath : File
 * 	totalFrames : int
 * 	selectedFiles : Vector.<File>
 * 	currentFilePntr : int
 * 	createSubFolders : Boolean
 * 	contentScale : Number
 * 	
 **********************************************************************************************************************************************************************************/
package com.kurst.export.swfrender.settings {
	import flash.filesystem.File;

	public class RenderSettings {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var frameRate : int = 24
		// frame rate of loaded content
		public var backgroundColour : uint = 0xFFFFFF
		// background colour ( if not transparent )
		public var backgroundTransparent : Boolean = true;
		// is background transparent
		public var stopOnLastFrame : Boolean = false;
		// stop on last frame
		public var animationSecondsToStop : Number = 60
		// number of seconds to render
		public var outputPath : File;
		// path of folder to export to
		public var totalFrames : int;
		// total frames to render
		public var selectedFiles : Vector.<File>;
		// Vector of SWF files to export
		public var currentFilePntr : int = 0
		// Pointer to file being exported
		public var createSubFolders : Boolean = true;
		// auto create sub folder for each SWF exported
		public var contentScale : Number = 1;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _AVM : String;

		// ActionScript Virtual Machine of SWF being rendered
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function RenderSettings() : void {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * number of frames to render
		 * 
		 * @return
		 */
		public function getTotalFrames() : int {
			var result : int;

			if ( stopOnLastFrame ) {
				result = totalFrames;
			} else {
				result = animationSecondsToStop * frameRate;
			}

			return result;
		}

		/**
		 *  Set ActionScript Virtual Machine of SWF being exported
		 * 
		 * @param _avm : String either AvmProps.AVM1 || AvmProps.AVM2
		 */
		public function setAVM(_avm : String) : void {
			_AVM = _avm;

			if ( _AVM == AvmProps.AVM1 ) {
				stopOnLastFrame = false;
			}
		}

		/**
		 *  AVM type for current / rendering SWF. 
		 *  

		 * @param
		 * @return AvmProps.AVM1 || AvmProps.AVM2
		 */
		public function get AVM() : String {
			return _AVM;
		}
	}
}