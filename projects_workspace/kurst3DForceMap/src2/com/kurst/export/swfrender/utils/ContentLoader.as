/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.swfrenderer.renderer.utils.ContentLoader
 * Version 	  	: 1
 * Description 	: Content Loader / Load SWF file for PNGRenderer
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	loadContent( file : File )
 * 	unloadContent()
 *
 * EVENTS
 * 
 * 	com.kurst.swfrenderer.events.ContentLoaderEvent.LOAD_COMPLETE
 * 	com.kurst.swfrenderer.events.ContentLoaderEvent.CONTENT_ERROR
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.export.swfrender.utils {
	import com.kurst.events.eventDispatcher;
	import com.kurst.export.swfrender.events.ContentLoaderEvent;
	import com.kurst.export.swfrender.settings.AvmProps;

	import flash.display.ActionScriptVersion;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;

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
	public class ContentLoader extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var loader : Loader;
		// SWF content loader
		private var _currentFile : File;

		// Target file to load
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function ContentLoader() {
			super();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * loadContent( file : File ) : void 
		 * 
		 * Load content to process 
		 *  
		 * @param file : File - File to load
		 */
		public function loadContent(file : File) : void {
			unloadContent();

			_currentFile = file;

			loader = new Loader();
			// Load content to render

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
			loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler, false, 0, true);

			loader.load(new URLRequest(file.url));
		}

		/**
		 *  
		 * unloadContent() : void 
		 * 
		 * unload / nullify any content from the loader
		 * 
		 */
		public function unloadContent() : void {
			if ( loader != null ) {
				loader.unloadAndStop();
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler, false);

				loader = null;
			}

			_currentFile = null;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * initialize loaded content, and dispatch ContentLoaderEvent.LOAD_COMPLETE event;
		 * 
		 * 	ContentLoaderEvent.LOAD_COMPLETE:
		 * 	
		 * 		ContentLoaderEvent.AVM
		 * 		ContentLoaderEvent.content
		 * 		ContentLoaderEvent.totalFrames ( AS3 Only )
		 * 		ContentLoaderEvent.contentWidth
		 * 		ContentLoaderEvent.contentHeight 
		 * 
		 */
		private function initLoadedContent() : void {
			var loadCompleteEvent : ContentLoaderEvent = new ContentLoaderEvent(ContentLoaderEvent.LOAD_COMPLETE, true)
			var isAVM1 : Boolean = ( loader.contentLoaderInfo.actionScriptVersion == ActionScriptVersion.ACTIONSCRIPT2 )
			// Check loaded file action script version
			var mc : MovieClip

			if ( isAVM1 ) {
				// AVM1 - AS2

				loadCompleteEvent.AVM = AvmProps.AVM1;
				loadCompleteEvent.content = loader;
			} else {
				// AVM2  - AS3

				loadCompleteEvent.AVM = AvmProps.AVM2
				loadCompleteEvent.content = loader.content;
				mc = loader.content as MovieClip;

				if ( mc )
					loadCompleteEvent.totalFrames = mc.totalFrames;
			}

			loadCompleteEvent.contentWidth = loader.contentLoaderInfo.width
			loadCompleteEvent.contentHeight = loader.contentLoaderInfo.height

			dispatchEvent(loadCompleteEvent);
		}

		/**
		 * 
		 * Catch errors in the loaded content - usually these tend to be AddedToStage misconfigurations, access to External Data ( without -use-network=false ), and script errors.
		 * 
		 * Dispatch ContentLoaderEvent.CONTENT_ERROR:
		 * 	
		 * 		ContentLoaderEvent.errorID
		 * 		ContentLoaderEvent.filename
		 * 		
		 * @param event:UncaughtErrorEvent
		 */
		private function uncaughtErrorHandler(event : UncaughtErrorEvent) : void {
			var result : String;
			var error : Error;
			var errorEvent : ErrorEvent;

			if (event.error is Error) {
				error = event.error as Error;
				result = error.message
			} else if (event.error is ErrorEvent) {
				errorEvent = event.error as ErrorEvent;
				result = 'ErrorEvent: ' + errorEvent.errorID + ' ' + errorEvent.type;
			} else {
				result = 'GeneralError: ' + event.toString();
			}

			var e : ContentLoaderEvent = new ContentLoaderEvent(ContentLoaderEvent.CONTENT_ERROR, true)
			e.message = result;
			e.filename = _currentFile.name;
			dispatchEvent(e);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 *  loader / complete event handler
		 * 
		 * @param load complete / loader event handler
		 */
		private function loadComplete(event : Event) : void {
			initLoadedContent();
		}
	}
}