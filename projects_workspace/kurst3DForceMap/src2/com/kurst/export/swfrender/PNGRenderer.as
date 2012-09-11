/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.swfrenderer.renderer.PNGRenderer
 * Description 	: Export PNG Sequence from SWF file 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 	
 * 	startRender( rs : RenderSettings ) : Boolean
 * 	stopRender() : void
 *
 * EVENTS
 * 
 * 	com.kurst.swfrenderer.events.ContentLoaderEvent.LOAD_COMPLETE
 * 	com.kurst.swfrenderer.events.ContentLoaderEvent.CONTENT_ERROR
 * 	com.kurst.swfrenderer.events.RenderEvent.RENDER_COMPLETE
 * 	com.kurst.swfrenderer.events.RenderEvent.START_RENDER
 * 	com.kurst.swfrenderer.events.RenderEvent.STOP_RENDER
 * 	com.kurst.swfrenderer.events.RenderEvent.SELECT_NEXT_FILE
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.export.swfrender {
	import by.blooddy.crypto.image.PNGEncoder;

	import com.kurst.air.FileIO;
	import com.kurst.export.swfrender.data.ErrorMessage;
	import com.kurst.export.swfrender.events.ContentLoaderEvent;
	import com.kurst.export.swfrender.events.RenderEvent;
	import com.kurst.export.swfrender.settings.AvmProps;
	import com.kurst.export.swfrender.settings.RenderSettings;
	import com.kurst.export.swfrender.settings.RenderValidationError;
	import com.kurst.export.swfrender.utils.ContentLoader;
	import com.kurst.utils.StrUtils;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	/**
	 * 
	 * @eventType com.kurst.swfrenderer.events.ContentLoaderEvent.LOAD_COMPLETE
	 */
	[Event(name="LOAD_COMPLETE", type="com.kurst.export.swfrender.events.ContentLoaderEvent")]
	/**
	 * 
	 * @eventType com.kurst.swfrenderer.events.ContentLoaderEvent.CONTENT_ERROR
	 */
	[Event(name="CONTENT_ERROR", type="com.kurst.export.swfrender.events.ContentLoaderEvent")]
	/**
	 * 
	 * @eventType RenderEvent.RENDER_COMPLETE
	 */
	[Event(name="RENDER_COMPLETE", type="com.kurst.export.swfrender.events.RenderEvent")]
	/**
	 * 
	 * @eventType RenderEvent.START_RENDER
	 */
	[Event(name="START_RENDER", type="com.kurst.export.swfrender.events.RenderEvent")]
	/**
	 * 
	 * @eventType RenderEvent.STOP_RENDER
	 */
	[Event(name="STOP_RENDER", type="com.kurst.export.swfrender.events.RenderEvent")]
	/**
	 * 
	 * @eventType RenderEvent.SELECT_NEXT_FILE
	 */
	[Event(name="SELECT_NEXT_FILE", type="com.kurst.export.swfrender.events.RenderEvent")]
	public class PNGRenderer extends Sprite {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var renderCompleteCounter : int = 0;
		private var imgSequenceCounter : int = 0;
		private var postfix : String = '.png';
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var fileIO : FileIO;
		private var basePath : File;
		private var prefix : String
		private var content : DisplayObject;
		private var contentLoader : ContentLoader;
		private var contentRenderPath : File;
		private var bitmapData : BitmapData;
		private var renderSettings : RenderSettings;
		private var captureWidth : Number;
		private var captureHeight : Number;
		private var errorMessages : Vector.<ErrorMessage>;
		private var createSubFolders : Boolean = true;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function PNGRenderer() {
			fileIO = new FileIO();

			contentLoader = new ContentLoader();
			contentLoader.addEventListener(ContentLoaderEvent.LOAD_COMPLETE, onContentLoadComplete, false, 0, true);
			contentLoader.addEventListener(ContentLoaderEvent.CONTENT_ERROR, onContentLoadError, false, 0, true);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 *  initialize a render process
		 *  
		 * 
		 * @param rs : RenderSettings
		 * @return true if render is started / false otherwise
		 */
		public function startRender(rs : RenderSettings) : Boolean {
			var result : Boolean = validateRenderSettings(rs);

			if ( result ) {
				errorMessages = new Vector.<ErrorMessage>();
				renderCompleteCounter = 0;
				renderSettings = rs;
				basePath = renderSettings.outputPath;
				createSubFolders = renderSettings.createSubFolders;

				loadNextFile();
			}

			return result;
		}

		/**
		 * 
		 * stop a render process
		 * 
		 */
		public function stopRender() : void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);

			if ( bitmapData != null )
				bitmapData.dispose();

			bitmapData = null;
			content = null;

			var renderEvent : RenderEvent = new RenderEvent(RenderEvent.STOP_RENDER, true, true);
			renderEvent.frame = imgSequenceCounter;
			renderEvent.settings = renderSettings;
			renderEvent.errorMessages = errorMessages;
			renderEvent.totalFiles = renderSettings.selectedFiles.length;
			renderEvent.totalSuccess = renderCompleteCounter + 1;

			dispatchEvent(renderEvent)
			contentLoader.unloadContent();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 *  validate render settings
		 *  
		 * 
		 * @param rs : RenderSettings
		 * @return true is valid for render / false otherwise
		 */
		private function validateRenderSettings(rs : RenderSettings) : Boolean {
			var result : Boolean = true;
			var errorMessage : String;

			if ( rs.selectedFiles == null ) {
				result = false;
				errorMessage = RenderValidationError.NO_FILES_TO_RENDER
			} else {
				if ( !rs.selectedFiles.length > 0 ) {
					result = false;
					errorMessage = RenderValidationError.NO_FILES_TO_RENDER
				}
			}

			if ( rs.outputPath == null ) {
				result = false;
				errorMessage = RenderValidationError.OUTPUT_INVALID
			} else {
				if ( !rs.outputPath.isDirectory ) {
					result = false;
					errorMessage = RenderValidationError.OUTPUT_INVALID
				}
			}

			if ( result == false )
				throw new Error(errorMessage);

			return result;
		}

		/**
		 *  
		 * load the next file in the render queue
		 * 
		 * @return true if there is a next file in the queue / false otherwise
		 */
		private function loadNextFile() : Boolean {
			if ( !checkAllFilesProcessed() ) {
				var fileName : String = StrUtils.replaceChar(renderSettings.selectedFiles[ renderSettings.currentFilePntr ].name, '.' + renderSettings.selectedFiles[ renderSettings.currentFilePntr ].extension, '');

				prefix = fileName + '_';

				selectContentRenderPath(fileName);
				loadContent(renderSettings.selectedFiles[ renderSettings.currentFilePntr ]);

				var renderEvent : RenderEvent = new RenderEvent(RenderEvent.SELECT_NEXT_FILE, true, true);
				renderEvent.totalFiles = renderSettings.selectedFiles.length;
				renderEvent.currentFile = renderSettings.currentFilePntr + 1;
				dispatchEvent(renderEvent)

				renderSettings.currentFilePntr++;

				return true;
			}

			return false;
		}

		/**
		 *  
		 * select the content path / store file reference
		 * 
		 * @param folderName - name of subfolder for the animation
		 */
		private function selectContentRenderPath(folderName : String) : void {
			if ( createSubFolders ) {
				contentRenderPath = new File(basePath.nativePath + '/' + folderName);

				if ( !contentRenderPath.exists )
					contentRenderPath.createDirectory();
			} else {
				contentRenderPath = basePath
			}
			;
		}

		// CONTENT ---------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * set the render content / SWF / Display object to capture
		 * 
		 * @param obj : DisplayObject 
		 */
		private function setRenderContent(obj : DisplayObject) : void {
			content = obj;
		}

		/**
		 * 
		 * set the render size
		 * 
		 * @param w : width
		 * @param h : height
		 */
		private function setRenderSize(w : Number, h : Number) : void {
			captureWidth = w;
			captureHeight = h;
		}

		/**
		 *  
		 *  load SWF / content to render
		 *  
		 * 
		 * @param f : File - path to the SWF that will be captured
		 */
		private function loadContent(f : File) : void {
			contentLoader.loadContent(f);
		}

		// RENDER ---------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * check if all files have been processed
		 * 
		 * @return true if all queue / files have been rendered || false if there is more in queue to render
		 */
		private function checkAllFilesProcessed() : Boolean {
			return !( renderSettings.currentFilePntr < renderSettings.selectedFiles.length )
		}

		/**
		 *  
		 *  Render a frame and export PNG - this is the workhorse
		 * 
		 */
		private function renderFrame() : void {
			if ( !checkStopRender() ) {
				// Clear Bitmap
				if ( renderSettings.backgroundTransparent )
					bitmapData.fillRect(bitmapData.rect, 0x00000000); // transparent
				else
					bitmapData.fillRect(bitmapData.rect, renderSettings.backgroundColour);
				// non - transparent

				var mt : Matrix = new Matrix();
				mt.scale(renderSettings.contentScale, renderSettings.contentScale);
				// scale the bitmap ( if required )

				bitmapData.draw(content, mt)
				// , null , null , null , bitmapData.rect , true )// Capture Content

				saveFrame(bitmapData);
				// save frame

				var renderEvent : RenderEvent = new RenderEvent(RenderEvent.ON_RENDER_FRAME, true);
				// Update / Render frame event
				renderEvent.frame = imgSequenceCounter;
				renderEvent.settings = renderSettings;
				dispatchEvent(renderEvent)
			}
		}

		/**
		 *  
		 * save the frame to file
		 *  
		 * 
		 * @param bmp : BitmapData - bitmapdata to encode to PNG
		 */
		protected function saveFrame(bmp : BitmapData) : void {
			var b : ByteArray = PNGEncoder.encode(bmp);
			// Encode PNG
			var f : File = new File(contentRenderPath.nativePath + '/' + prefix + ( imgSequenceCounter++ ) + postfix);
			// Target PNG File

			fileIO.writeBinaryFile(f, b);
			// Write File
		}

		/**
		 *  
		 * check if the current file has been rendered / whether it's reached last frame or alloted time
		 * 
		 */
		private function checkStopRender() : Boolean {
			if ( imgSequenceCounter >= renderSettings.getTotalFrames() ) {
				// check if sequence is complete

				if ( loadNextFile() ) {
					// Check and load next file if there is one in queue

					renderCompleteCounter++;
					pauseRender();

					return true;
				} else {
					stopRender();

					var renderEvent : RenderEvent
					renderEvent = new RenderEvent(RenderEvent.RENDER_COMPLETE, true, true);
					renderEvent.frame = imgSequenceCounter;
					renderEvent.settings = renderSettings;
					renderEvent.errorMessages = errorMessages;
					renderEvent.totalSuccess = renderCompleteCounter + 1;
					dispatchEvent(renderEvent)

					return true;
				}
			}

			return false;
		}

		/**
		 *  
		 * start render process - once content is loaded
		 * 
		 */
		private function _startRender() : void {
			imgSequenceCounter = 0;

			var renderEvent : RenderEvent = new RenderEvent(RenderEvent.START_RENDER, true, true);
			renderEvent.frame = imgSequenceCounter;
			renderEvent.settings = renderSettings;
			dispatchEvent(renderEvent)

			if ( renderSettings.backgroundTransparent ) {
				bitmapData = new BitmapData(captureWidth * renderSettings.contentScale, captureHeight * renderSettings.contentScale, true, 0x00000000);
			} else {
				bitmapData = new BitmapData(captureWidth * renderSettings.contentScale, captureHeight * renderSettings.contentScale, false, renderSettings.backgroundColour);
			}

			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
			renderFrame();
		}

		/**
		 *  
		 * Pause a render process
		 * 
		 * @param flag - true to pause - false to resume
		 */
		private function pauseRender(flag : Boolean = true) : void {
			if ( flag ) {
				removeEventListener(Event.ENTER_FRAME, enterFrame);
			} else {
				addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * Content Load error - here is a problem with loaded content
		 * 
		 */
		private function onContentLoadError(event : ContentLoaderEvent) : void {
			var errorMsg : ErrorMessage = new ErrorMessage();
			errorMsg.errorMessage = event.message;
			errorMsg.fileName = event.filename;
			errorMessages.push(errorMsg);

			dispatchEvent(event.clone());
			loadNextFile();
		}

		/**
		 * 
		 * Content loaded
		 * 
		 */
		private function onContentLoadComplete(event : ContentLoaderEvent) : void {
			if ( event.AVM == AvmProps.AVM2 )
				renderSettings.totalFrames = event.totalFrames;

			renderSettings.setAVM(event.AVM);

			setRenderSize(event.contentWidth, event.contentHeight);
			setRenderContent(event.content);

			_startRender();

			dispatchEvent(event.clone())
		}

		/**
		 *  
		 * Enter Frame event handler / tick for render process
		 * 
		 */
		private function enterFrame(e : Event) : void {
			renderFrame();
		}
	}
}