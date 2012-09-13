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
	import com.kurst.controls.gallery3d.fx.FxRenderer;

	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.objects.special.ParticleField;
	import org.papervision3d.materials.special.ParticleMaterial;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StarField extends FxRenderer {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var rotationSpeed : Number = 0.5
		public var rotationIncrement : Number = 0.05
		public var particleAlpha : Number = .5
		public var particleColour : Number = 0xFFFFFF
		public var quantity : Number = 800
		public var particleSize : Number = 5
		public var fieldWidth : Number = 18000
		public var fieldHeight : Number = 8000
		public var fieldDepth : Number = 8000
		/*
		private var selectedRecord 		: Object;
		
		private var renderer			: BasicRenderEngine
		private var scene				: Scene3D
		private var camera				: CameraObject3D
		private var viewport			: Viewport3D
		 */
		private var particleField : ParticleField;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function StarField() {
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
		override public function render() : void {
			particleField.rotationY += ( particleField.rotationY - ( particleField.rotationY + rotationIncrement ) ) * rotationSpeed
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function init(_renderer : BasicRenderEngine = null, _scene : Scene3D = null, _camera : CameraObject3D = null, _viewport : Viewport3D = null) : void {
			renderer = _renderer
			scene = _scene
			camera = _camera
			viewport = _viewport

			// scene.addChild( physics.getMesh(ball) );
			var particleMaterial : ParticleMaterial = new ParticleMaterial(particleColour, particleAlpha);

			particleField = new ParticleField(particleMaterial, quantity, particleSize, fieldWidth, fieldHeight, fieldDepth)
			//

			scene.addChild(particleField)

			/*
			P
			p;articleField  = new ParticleField(_pm, 800, 5, 8000, 8000, 8000);
			
			
			
			// _pf.y = 1000
			// scene.addChild(_pf);
			
			view.pv3dView.scene.addChild(_pf)
			

			pTimer = new Timer( 60 );
			pTimer.addEventListener( TimerEvent.TIMER, pTimerEvent , false , 0 , true )
			pTimer.start()
			 * 
			 */
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function destroy() : void {
			renderer = null;
			scene = null;
			camera = null;
			viewport = null;
		}
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// GGGGG  EEEEEEE TTTTTT          SSSSS EEEEEEE TTTTTT 
		// GG      EE        TT           SS     EE        TT   
		// GG  GGG EEEE      TT            SSSS  EEEE      TT   
		// GG   GG EE        TT               SS EE        TT   
		// GGGGG  EEEEEEE   TT           SSSSS  EEEEEEE   TT   
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------

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
