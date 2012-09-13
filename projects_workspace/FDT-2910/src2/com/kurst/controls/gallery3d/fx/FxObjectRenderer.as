/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: karimbeyrouti
 * Version 	  	: com.kurst.controls.gallery3d.renderer.GalleryRenderer
 * Description 	: Base Class for gallery renderer's
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Kb 
 * Date 			: 27/05/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 		destroy()
 * 		setRenderData( a : Array ) : void
 * 		setGallerySettings( settings : GallerySettings ) : void
 * 		setRenderSettings( s : * ) : void
 * 		getRenderSettings( ) : *
 * 		render( selectedID : Number,  invalidate : Boolean = false ) : void
 *
 * EVENTS
 * 
 * 		Gallery3dEvent.SCROLL_COMPLETE
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.fx {
	import com.kurst.events.Gallery3dEvent;
	import com.kurst.pv3d.objects.PlaneX;
	import com.kurst.controls.gallery3d.settings.GallerySettings;

	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D
	// import org.papervision3d.core.proto.CameraObject3D;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FxObjectRenderer {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var selectedRecord : Object;
		public var renderer : BasicRenderEngine
		public var scene : Scene3D
		public var camera : CameraObject3D
		public var viewport : Viewport3D

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function FxObjectRenderer() {
			super();
		}

		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  UU   UU BBBBBB  LL      IIIIII  CCCCC
		// PP   PP UU   UU BB   BB LL        II   CC   CC
		// PPPPPP  UU   UU BBBBBB  LL        II   CC
		// PP      UU   UU BB   BB LL        II   CC   CC
		// PP       UUUUU  BBBBBB  LLLLLLL IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function init(_renderer : BasicRenderEngine = null, _scene : Scene3D = null, _camera : CameraObject3D = null, _viewport : Viewport3D = null) : void {
			renderer = _renderer
			scene = _scene
			camera = _camera
			viewport = _viewport
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			renderer = null;
			scene = null;
			camera = null;
			viewport = null;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function select(e : Gallery3dEvent = null) : void {
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function deSelect(e : Gallery3dEvent = null) : void {
		}
	}
}
