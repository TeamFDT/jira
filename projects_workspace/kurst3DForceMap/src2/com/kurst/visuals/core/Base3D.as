package com.kurst.visuals.core {
	import flash.events.Event;

	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.view.IView;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D

	/**
	 * @Author Ralph Hauwert
	 */
	public class Base3D extends AbstractComp implements IView {
		protected var _camera : CameraObject3D;
		protected var _height : Number;
		protected var _width : Number;
		public var scene : Scene3D;
		public var viewport : Viewport3D;
		public var renderer : BasicRenderEngine;

		public function Base3D(width : Number, height : Number) {
			super(width, height);
		}

		public function startRendering() : void {
			addEventListener(Event.ENTER_FRAME, onRenderTick);
			viewport.containerSprite.cacheAsBitmap = false;
		}

		public function stopRendering(reRender : Boolean = false, cacheAsBitmap : Boolean = false) : void {
			removeEventListener(Event.ENTER_FRAME, onRenderTick);
			if (reRender) {
				onRenderTick();
			}
			if (cacheAsBitmap) {
				if ( viewport != null )
					viewport.containerSprite.cacheAsBitmap = true;
			} else {
				if ( viewport != null )
					viewport.containerSprite.cacheAsBitmap = false;
			}
		}

		public function singleRender() : void {
			onRenderTick();
		}

		protected function onRenderTick(event : Event = null) : void {
			renderer.renderScene(scene, _camera, viewport);
		}

		public function get camera() : CameraObject3D {
			return _camera;
		}

		public function set viewportWidth(width : Number) : void {
			_width = width;
			viewport.width = width;
		}

		public function get viewportWidth() : Number {
			return _width;
		}

		public function set viewportHeight(height : Number) : void {
			_height = height;
			viewport.height = height;
		}

		public function get viewportHeight() : Number {
			return _height;
		}
	}
}