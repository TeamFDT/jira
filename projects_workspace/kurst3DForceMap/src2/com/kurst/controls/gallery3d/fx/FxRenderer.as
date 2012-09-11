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

	public class FxRenderer {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var selectedRecord : Object;
		public var renderer : BasicRenderEngine
		public var scene : Scene3D
		public var camera : CameraObject3D
		public var viewport : Viewport3D

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function FxRenderer() {
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
		// public function select
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function render() : void {
		}

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
		public function navigateTo(e : Gallery3dEvent) : void {
		}
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// EEEEEEE V     V EEEEEEE NN  NN TTTTTT         HH   HH   AAA   NN  NN DDDDDD  LL      EEEEEEE RRRRR    SSSSS 
		// EE      V     V EE      NNN NN   TT           HH   HH  AAAAA  NNN NN DD   DD LL      EE      RR  RR  SS     
		// EEEE     V   V  EEEE    NNNNNN   TT           HHHHHHH AA   AA NNNNNN DD   DD LL      EEEE    RRRRR    SSSS  
		// EE        V V   EE      NN NNN   TT           HH   HH AAAAAAA NN NNN DD   DD LL      EE      RR  RR      SS 
		// EEEEEEE    V    EEEEEEE NN  NN   TT           HH   HH AA   AA NN  NN DDDDDD  LLLLLLL EEEEEEE RR   RR SSSSS  
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}
