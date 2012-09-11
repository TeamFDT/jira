package com.kurst.air.utils {
	
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;

	public class WindowUtils {
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function createOutputWindow(content : Sprite, title : String = '', wOpt : NativeWindowInitOptions = null, bounds : Rectangle = null, screenID : int = 0, extendOnScreen : Boolean = false) : NativeWindow {
			
			var screenArray : Array = Screen.screens;
			screenID = ( screenID < screenArray.length ) ? screenID : 0 ;
			var screen : Screen = screenArray[screenID] as Screen;

			if ( bounds == null ) {
				bounds = new Rectangle(0, 0, 1024, 768);
			}

			if ( wOpt == null ) {
				wOpt = new NativeWindowInitOptions();
				wOpt.systemChrome = NativeWindowSystemChrome.STANDARD;
				wOpt.systemChrome = ( screen == null || !extendOnScreen ) ? NativeWindowSystemChrome.STANDARD : NativeWindowSystemChrome.NONE;
				wOpt.type = NativeWindowType.NORMAL;
				wOpt.transparent = false;
				wOpt.renderMode = 'gpu';
			}

			var outputWindow : NativeWindow = new NativeWindow(wOpt);
			outputWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			outputWindow.stage.align = StageAlign.TOP_LEFT;
			outputWindow.title = title;

			if ( screen != null && extendOnScreen ) {
				outputWindow.bounds = new Rectangle(0, 0, screen.bounds.width, screen.bounds.height);
				outputWindow.x = screen.bounds.left;
				outputWindow.y = screen.bounds.top;
			} else {
				outputWindow.bounds = bounds;

				if ( screen != null ) {
					outputWindow.x = screen.bounds.left + ( screen.bounds.width - outputWindow.bounds.width ) / 2;
					outputWindow.y = screen.bounds.top + ( screen.bounds.height - outputWindow.bounds.height ) / 2;
				} else {
					outputWindow.x = ( Screen.mainScreen.bounds.width - outputWindow.bounds.width) / 2;
					outputWindow.y = 0;
				}
			}

			outputWindow.stage.addChild(content);
			outputWindow.activate();

			return outputWindow;
		}
	}
}
