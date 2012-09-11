package com.kurst.video.tracking.renderer {
	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.data.TrackData;
	import com.kurst.video.tracking.data.render.ZOrderDataItem;
	import com.kurst.video.tracking.utils.ZOrderUtil;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class RendererBase implements IRenderer {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var bitmapData : BitmapData;
		public var drawContainer : Sprite;
		public var timelineData : Tracker;
		public var trackData : TrackData;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var container : Sprite;
		private var nestChildSprite : Sprite;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * init( _timelineData : TimelineDataItem ) : void
		 * 
		 * @param
		 * @return
		 */
		public function init(_timelineData : Tracker) : void {
			timelineData = _timelineData;
			trackData = _timelineData.data;

			if ( _timelineData.bitmapData )
				initBitmapData(_timelineData.bitmapData);

			if ( _timelineData.drawSprite  )
				initContainer(_timelineData.drawSprite, _timelineData.nestChildName);

			setBlendMode(_timelineData.blendMode);

			ZOrderUtil.addTraker(drawContainer, timelineData);
		}

		/**
		 * 
		 * render(frame : int) : void 
		 * 
		 * @param
		 * @return
		 */
		public function render(frame : int) : void {
			
			/* OVERRIDE */
		}

		/**
		 *  
		 * destroy() : void 
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			ZOrderUtil.removeTraker(timelineData);

			if ( nestChildSprite ) {
				if ( nestChildSprite.contains(drawContainer) )
					nestChildSprite.removeChild(drawContainer);
			} else {
				if ( container.contains(drawContainer) )
					container.removeChild(drawContainer);
			}

			drawContainer = null;
			bitmapData = null;
			timelineData = null;
			trackData = null;
		}

		/**
		 *  
		 * updateData( _timelineData : Tracker ) : void
		 * 
		 * @param
		 * @return
		 */
		public function updateData(_timelineData : Tracker) : void {
			destroy();
			init(_timelineData);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method setBitmapData( bmp : BitmapData ) : void
		 * @tooltip bitmapData that will be transformed into the video
		 * @param BitmapData
		 */
		private function initBitmapData(bmp : BitmapData) : void {
			if ( bitmapData )
				bitmapData.dispose();

			if ( bmp ) {
				bitmapData = null;
				bitmapData = bmp;
			}
		}

		/**
		 * @method setContainer( displayObject : Sprite , nestChildName : String = null ) : void
		 * @tooltip set the container to render the bitmap
		 * @param displayObject : Sprite - Timeline
		 * @param nestChildName : String = null - Name of Sprite / MovieClip container
		 */
		private function initContainer(displayObject : Sprite, containerSubNestSpriteName : String = null) : void {
			container = displayObject;

			if ( containerSubNestSpriteName )
				nestChildSprite = container[containerSubNestSpriteName];

			drawContainer = new Sprite();

			if ( nestChildSprite ) {
				nestChildSprite.addChild(drawContainer);
			} else {
				container.addChild(drawContainer);
			}
		}

		/**
		 * @method setBlendMode( str : String ) : void 
		 * @tooltip set the blend mode of a personalisation / timeline render item
		 * @param BlendMode
		 */
		private function setBlendMode(str : String) : void {
			if ( container && str != null )
				drawContainer.blendMode = str;
		}
	}
}
