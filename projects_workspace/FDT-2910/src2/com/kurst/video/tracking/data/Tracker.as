/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.tracking.data.TimelineDataItem
 * Version 	  	: 1
 * Description 	: Timeline data item - track information
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti 
 * Date 			: 07/11/11
 * 
 ********************************************************************************************************************************************************************************
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.data {
	import flash.geom.Rectangle;

	import com.kurst.video.tracking.core.TrackRenderer;
	import com.kurst.video.tracking.settings.TrackType;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class Tracker {
		// Track Data ID
		public var id : String;
		// Animation Start Frame
		public var startFrame : int;
		// Animation End Frame
		public var endFrame : int;
		// Tracking Data
		public var data : TrackData;
		// Target Draw Sprite
		public var drawSprite : Sprite;
		// Target Nested sprite name
		public var nestChildName : String;
		// BitmapData / tracking image
		public var bitmapData : BitmapData;
		// BlendMode
		public var blendMode : String;
		// Track X Scale
		public var scaleX : Number = 1;
		// Track Y Scale
		public var scaleY : Number = 1;
		// xOffset
		public var yOffset : int = 0;
		// yOffset
		public var xOffset : int = 0;
		// Track type
		public var type : String = TrackType.FOUR_POINT;
		// Z order of tracking container
		public var zOrder : int = 0;
		// YXSRenderer - default content scaleX
		public var contentScaleX : Number = 1;
		// YXSRenderer - default content scaleY
		public var contentScaleY : Number = 1;
		// YXSRenderer - Scale image to fit in the rect
		public var scaleRect : Rectangle;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// track active flag
		public var isActive : Boolean = false;
		//
		public var debug : Boolean = false;
		// Track renderer
		public var renderer : TrackRenderer;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function updateBitmap(bmp : BitmapData) : void {
			bitmapData = bmp;

			if ( renderer )
				renderer.updateData(this);
		}
	}
}