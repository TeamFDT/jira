/********************************************************************************************************************************************************************************
 * 	
 * 	MovieClip utilities
 *
 *********************************************************************************************************************************************************************************
 *
 * 	Static Functions
 * 
 * 		porportionalScaleTo( mc:MovieClip, left:Number, right:Number, top:Number, bottom:Number ):Boolean
 *		duplicateDisplayObject(target:MovieClip, parent:MovieClip = null, autoAdd:Boolean = false):Sprite 
 *		getURL(url:String, window:String = null)
 *		createBitmapFromLinkageID( asset:String ):Bitmap
 *		functionExists(obj:Object,name:String):Boolean
 *
 *********************************************************************************************************************************************************************************
 *********************************************************************************************************************************************************************************/
package com.kurst.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	public class MovieUtils {
		// -STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// SSSSS TTTTTT   AAA   TTTTTT IIIIII  CCCCC
		// SS       TT    AAAAA    TT     II   CC   CC
		// SSSS    TT   AA   AA   TT     II   CC
		// SS   TT   AAAAAAA   TT     II   CC   CC
		// SSSSS    TT   AA   AA   TT   IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function createMcFromClassString(_symbol : String) : MovieClip {
			var classDefintion : Class = getDefinitionByName(_symbol) as Class;
			return new classDefintion();
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function createMcFromLinkageID(_symbol : String) : MovieClip {
			var classDefintion : Class = getDefinitionByName(_symbol) as Class;
			return ( new classDefintion() as MovieClip )
		}

		/**
		 * porportionally scale a movieclip to the specified bounds
		 * 
		 * @usage   movieUtils.porportionalScaleTo( mc, 0, 500, 0, 400 );
		 * 
		 * @param   mc 		- movieclip to scale
		 * @param   left
		 * @param   right
		 * @param   top
		 * @param   bottom
		 * 
		 * @return  Boolean - true if image is in portrait mode - false if image is landscape
		 */
		public static function porportionalScaleTo(mc : *, left : Number, right : Number, top : Number, bottom : Number) : Boolean {
			if ( mc == null ) return false;

			mc.scaleX = mc.scaleY = 1
			// 00

			var targetWidth : Number = right - left;
			var targetHeight : Number = bottom - top;
			var w_scalar : Number = targetWidth / mc.width ;
			var h_scalar : Number = targetHeight / mc.height ;

			mc.scaleX = mc.scaleY = h_scalar * 1
			// 00;

			if ( mc.width > targetWidth ) {
				mc.scaleX = mc.scaleY = 1
				// 00;
				mc.scaleX = mc.scaleY = w_scalar * 1
				// 00;
			}

			mc.y = ( ( targetHeight - mc.height ) / 2 ) + top;
			mc.x = ( ( targetWidth - mc.width  ) / 2 ) + left;

			return !( mc.width > mc.height )
		}

		/**
		 * duplicateDisplayObject
		 * 
		 * creates a duplicate of the DisplayObject passed.
		 * similar to duplicateMovieClip in AVM1
		 * 
		 * @param target the display object to duplicate
		 * @param autoAdd if true, adds the duplicate to the display list
		 * in which target was located
		 * 
		 * @return a duplicate instance of target

		public static function duplicateDisplayObject(target:MovieClip, parent:MovieClip = null, autoAdd:Boolean = false):Sprite {
			
		// create duplicate
		var targetClass	: Class 		= Object(target).constructor;
		    
		var duplicate	: MovieClip 	= new targetClass();// duplicate properties
		duplicate.transform 		= target.transform;
		duplicate.filters 			= target.filters;
		duplicate.cacheAsBitmap		= target.cacheAsBitmap;
		duplicate.opaqueBackground 	= target.opaqueBackground;
			
		if (target.scale9Grid) {
				
		var rect:Rectangle = target.scale9Grid;
		rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
	
		duplicate.scale9Grid = rect;
		}

		// add to target parent's display list
		// if autoAdd was provided as true
		
		if (autoAdd && parent)
		parent.addChild(duplicate);

		return duplicate;
		}
		 */
		/**
		 * porportionally scale a movieclip to the specified bounds
		 * 
		 * @usage   movieUtils.getURL(url:String, window:String = null)
		 * 
		 * @param   url 		- URL
		 * @param   window	- Window
		 */
		public static function getURL(url : String, window : String = null) : void {
			var req : URLRequest = new URLRequest(url);

			try {
				navigateToURL(req, window);
			} catch (e : Error) {
				trace("com.kurst.utils.movieUtils.getURL.FAILED: ", e.message);
			}
		}

		/**
		 * Create a Bitmap object from a symbol in the library
		 * 
		 * @usage   addChild (  movieUtils.createBitmapFromLinkageID("roadBmp") );
		 * 
		 * @param   asset:String - LinkageId of the bitmapData asset
		 * @return  a bitmap object
		 */
		public static function createBitmapFromLinkageID(asset : String) : Bitmap {
			var BitmapAsset : Class = getDefinitionByName(asset) as Class;
			var bitmapdata : BitmapData = new BitmapAsset(0, 0) as BitmapData;
			var bitmap : Bitmap = new Bitmap()
			bitmap.bitmapData = bitmapdata

			return bitmap;
		}

		/**
		 * Test if a function exists in a specified object
		 * 
		 * @usage   functionExists( this, "render" );
		 * 
		 * @param   obj - object to test
		 * @param   name - function name
		 * @return  true/false
		 */
		public static function functionExists(obj : Object, name : String) : Boolean {
			if ( obj == null ) return false;

			if (obj.hasOwnProperty(name)) {
				return true;
			} else {
				return false;
			}
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function resizeBitmap(originalBitmap : Bitmap, scaleFactor : Number) : BitmapData {
			// trace('resize')
			var mu : MovieUtils = MovieUtils.getInstance();

			if ( mu.scaledBitmapData != null ) {
				mu.scaledBitmapData.dispose();
				mu.scaledBitmapData = null;
			}

			// var originalBitmapData	: BitmapData	= originalBitmap.bitmapData;
			var newWidth : Number = originalBitmap.bitmapData.width * scaleFactor;
			var newHeight : Number = originalBitmap.bitmapData.height * scaleFactor;

			mu.scaledBitmapData = new BitmapData(newWidth, newHeight, true, 0x00FFFFFF);

			var scaleMatrix : Matrix = new Matrix();
			scaleMatrix.scale(scaleFactor, scaleFactor);

			mu.scaledBitmapData.draw(originalBitmap.bitmapData, scaleMatrix);

			FDelayCall.addCall(getInstance().clearBitmap, getInstance());

			return mu.scaledBitmapData.clone();
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function resizeBitmapData(originalBitmap : BitmapData, scaleFactor : Number) : BitmapData {
			// trace('resize')
			var mu : MovieUtils = MovieUtils.getInstance();

			if ( mu.scaledBitmapData != null ) {
				mu.scaledBitmapData.dispose();
				mu.scaledBitmapData = null;
			}

			// var originalBitmapData	: BitmapData	= originalBitmap.bitmapData;
			var newWidth : Number = originalBitmap.width * scaleFactor;
			var newHeight : Number = originalBitmap.height * scaleFactor;

			mu.scaledBitmapData = new BitmapData(newWidth, newHeight, true, 0x00FFFFFF);

			var scaleMatrix : Matrix = new Matrix();
			scaleMatrix.scale(scaleFactor, scaleFactor);

			mu.scaledBitmapData.draw(originalBitmap, scaleMatrix);

			FDelayCall.addCall(getInstance().clearBitmap, getInstance());

			return mu.scaledBitmapData.clone();
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public static function getInstance() : MovieUtils {
			if ( _inst == null ) _inst = new MovieUtils();
			return _inst;
		}

		// ------------------------------------------------------------------------------------------------------------------------------
		private static var _inst : MovieUtils;
		// ------------------------------------------------------------------------------------------------------------------------------
		public var scaledBitmapData : BitmapData;

		// ------------------------------------------------------------------------------------------------------------------------------
		public function MovieUtils() {
		}

		public function clearBitmap() : void {
			if ( scaledBitmapData != null ) {
				scaledBitmapData.dispose();
				scaledBitmapData = null;
			}
		}
	}
}