package com.kurst.visuals.compbase {
	import com.kurst.visuals.core.Base3D;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.cameras.DebugCamera3D;
	import org.papervision3d.cameras.SpringCamera3D;
	import org.papervision3d.core.view.IView;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	// import com.kurst.visual.settings.AppSettings;
	/**
	 * <p>
	 * BasicView provides a simple template for quickly setting up
	 * basic Papervision3D projects by creating a viewport, scene,
	 * camera, and renderer for you. Because BasicView is a subclass of
	 * Sprite, it can be added to any DisplayObject.
	 * 
	 * </p>
	 * 
	 * <p>
	 * <p>
	 * Example:
	 * </p>
	 * <pre><code>
	 * var width:Number = 640;
	 * var heigth:Number = 480;
	 * var scaleToStage:Boolean = true;
	 * var interactive:Boolean = true;
	 * var cameraType:String = Camera3D.TYPE;
	 * 
	 * var myBasicView:BasicView = new BasicView(width, height, scaleToStage, interactive, cameraType);
	 * myDisplayObject.addChild(myBasicView);
	 * </code></pre>
	 * </p>
	 * @author Ralph Hauwert
	 */
	public class Comp3D extends Base3D implements IView {
		/**
		 * @param viewportWidth		Width of the viewport 
		 * @param viewportHeight	Height of the viewport
		 * @param scaleToStage		Whether you viewport should scale with the stage
		 * @param interactive		Whether your scene should be interactive
		 * @param cameraType		A String for the type of camera. @see org.papervision3d.cameras.CameraType
		 * 
		 */
		public function Comp3D(viewportWidth : Number = 1000, viewportHeight : Number = 433, scaleToStage : Boolean = false, interactive : Boolean = false, cameraType : String = "Target") {
			super(viewportWidth, viewportHeight);

			scene = new Scene3D();
			viewport = new Viewport3D(viewportWidth, viewportHeight, scaleToStage, interactive);

			addChild(viewport);

			renderer = new BasicRenderEngine();

			switch(cameraType) {
				case CameraType.DEBUG:
					_camera = new DebugCamera3D(viewport);
					break;
				case CameraType.TARGET:
					_camera = new Camera3D(45);
					_camera.target = DisplayObject3D.ZERO;
					break;
				case CameraType.SPRING:
					_camera = new SpringCamera3D();
					_camera.target = DisplayObject3D.ZERO;
					break;
				case CameraType.FREE:
				default:
					_camera = new Camera3D(45);
					break;
			}

			cameraAsCamera3D.update(viewport.sizeRectangle);
		}

		/**
		 * Exposes the camera as a <code>Camera3D</code>
		 */
		public function get cameraAsCamera3D() : Camera3D {
			return _camera as Camera3D;
		}

		/**
		 * Exposes the camera as a <code>DebugCamera3D</code>
		 */
		public function get cameraAsDebugCamera3D() : DebugCamera3D {
			return _camera as DebugCamera3D;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function resize(stageWidth : int, stageHeight : int) : void {
			if ( stage == null ) return;

			super.resize(stageWidth, stageHeight);

			viewport.scaleX = viewport.scaleY = 1;
			var wRatio : Number = ( stage.stageWidth / viewport.viewportWidth )
			viewport.scaleX = viewport.scaleY = wRatio;
			var wHeight : Number = viewport.viewportHeight * viewport.scaleX ;

			viewport.y = ( stage.stageHeight - wHeight ) / 2;

			/* // Original Wella Code
			viewport.scaleX 		= viewport.scaleY = 1;
			var wRatio : Number 	= ( stage.stageWidth / 1000 ) 
			viewport.scaleX 		= viewport.scaleY = wRatio;
			var wHeight : Number 	= viewport.viewportHeight * viewport.scaleX ;

			viewport.y				= ( stage.stageHeight - wHeight ) / 2;
			 */
		}

		override public function destroy() : void {
			stopRendering();

			if ( viewport != null ) {
				viewport.destroy();

				try {
					if ( contains(viewport) )
						removeChild(viewport);
				} catch ( e : Error ) {
				}
				;
			}

			renderer = null;
			scene = null;
			_camera = null;
			viewport = null;

			super.destroy();
		}
	}
}