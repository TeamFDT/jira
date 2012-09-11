package com.kurst.controls.gallery3d.renderer {
	import com.kurst.controls.gallery3d.data.DateGridImageCollection;
	import com.kurst.controls.gallery3d.settings.GallerySettings;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	public interface IGalleryRenderer {
		// PUBLIC
		function render(selectedID : Number, invalidate : Boolean = false) : void

		function renderCamera(_camera : CameraObject3D, s : Stage = null) : void

		function init(_renderer : BasicRenderEngine = null, _scene : Scene3D = null, _camera : CameraObject3D = null, _viewport : Viewport3D = null) : void

		function destroy() : void

		function initNewItem(rec : Object) : void

		// GET / SET
		function set width(w : Number) : void

		function set height(h : Number) : void

		function get width() : Number

		function get height() : Number

		function get isDeselected() : Boolean

		function get selectedImageCollection() : DateGridImageCollection

		function setRenderData(a : Array) : void

		function setGallerySettings(settings : GallerySettings) : void

		function setRenderSettings(s : *) : void

		function getRenderSettings() : *

		// EVENTS
		function MouseDownEvent(e : MouseEvent) : void

		function MouseUpEvent(e : MouseEvent) : void

		function MouseMoveEvent(e : MouseEvent) : void

		function DragEvent(xPos : Number, yPos : Number) : void

		function AnimationComplete(e : Event = null) : void
	}
}
