/********************************************************************************************************************************************************************************
* 
* Class Name  	: 
* Version 	  	: 
* Description 	: 
* 
********************************************************************************************************************************************************************************
* 
* Author 		: Karim Beyrouti
* Date 			: 
* 
********************************************************************************************************************************************************************************
* 
* METHODS
* 
*
* PROPERTIES
* 
*
* EVENTS
* 
* 
********************************************************************************************************************************************************************************
* 				:
*
*
*********************************************************************************************************************************************************************************
* NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.away3d {
	import flash.display.Stage;
	import away3d.containers.ObjectContainer3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import away3d.controllers.HoverController;
	import flash.events.Event;
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.containers.Scene3D;
	import flash.display.Sprite;

	
	public class Away3DBase extends Sprite {
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		private var _scene						: Scene3D;
		private var _view 						: View3D;
		private var _camera						: Camera3D;
		private var _hoverController 			: HoverController;
		private var _antialias 					: uint = 2;
		private var _scaleToScage				: Boolean = false;

		//------------------------------------------------------------------------------------------------------------------------------------------------------------		
		// Hover Controller
		
		private var _move 						: Boolean = false;
		private var lastMouseX 					: Number;
		private var lastPanAngle 				: Number;
		private var lastMouseY 					: Number;
		private var lastTiltAngle				: Number;
		private var _cameraOffset 				: Number = 900;
		private var _hoverControllerEnabled 	: Boolean = false;
		private var _stage						: Stage;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function Away3DBase() {
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage , false ,0 , true );
			init();
			
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function render() : void {

			if ( _move ) {

				_hoverController.panAngle = 0.3 * (_stage.mouseX - lastMouseX) + lastPanAngle;
				_hoverController.tiltAngle = 0.3 * (_stage.mouseY - lastMouseY) + lastTiltAngle;

			}
			
			_view.render();
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function enableHoverController( flag : Boolean , camOffset : Number = NaN , lookAtPosition : Vector3D = null ) : void {
			
			_hoverControllerEnabled	 	= flag;
			_cameraOffset				= ( isNaN( camOffset ) ) ? _cameraOffset : camOffset;
			
			if ( flag ) {
				
				lookAtPosition = ( lookAtPosition ) ? lookAtPosition : new Vector3D( 0 , 0 , 0 );
				
				if ( ! _hoverController ){
					
					_hoverController = new HoverController(_camera, null, 45, 10, _cameraOffset );
					
				} else {
					
					_hoverController.targetObject = _camera;
					
				}
				
				_hoverController.lookAtPosition = lookAtPosition;
					
				if ( _stage ) {
								
					_stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown , false ,0 , true );
					_stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp , false ,0 , true );
			
				} 
				
			} else {
				
				enableHoverMouseWheel 			= false;
				
				_stage.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				_stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
				
				_move 							= false;
				_hoverController.targetObject 	= null;
				
			}

		}
		/**
		 * Adds a child to the scene's root.
		 * @param child The child to be added to the scene
		 * @return A reference to the added child.
		 */
		public function add3DChild(child : ObjectContainer3D) : ObjectContainer3D {
			return scene.addChild(child);
		}
		/**
		 * Removes a child from the scene's root.
		 * @param child The child to be removed from the scene.
		 */
		public function remove3DChild(child : ObjectContainer3D) : void {
			scene.removeChild(child);
		}
		/**
		 * 
		 * @param 
		 */
		public function dispose():void {

			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
			
			enableHoverController( false );
			enableHoverMouseWheel 	= false;
			scaleToScage			= false;
			_hoverController		= null;
			
			
			if ( _view ) {
				
				if ( _scene )
					_scene = null;
					
				
				
				removeChild( _view );
				_view.dispose();
				
				_view 			= null;
				
			}
			
			_stage = null;
		
			

		}
	
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function init() : void {
			

			addChild( _view = new View3D() );
			
			_scene 			= new Scene3D();
			_camera 		= new Camera3D();
			_view.scene 	= _scene;
			_view.antiAlias	= _antialias;
			_view.camera 	= _camera;


		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function initStage() : void {
			
			if ( _scaleToScage )
				_stage.addEventListener(Event.RESIZE, onResizeStage , false ,0 , true );
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function set enableHoverMouseWheel( b : Boolean ) : void {
			
			if ( b && _hoverControllerEnabled ){
				
				//trace('enableMouse');
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel , false ,0 , true );
				 
			} else {
				
				_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );
				
			}
				
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get width() : Number { return _view.width;}
		override public function set width(width : Number) : void {view.width = width;}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get height() : Number {return _view.height;}
		override public function set height(height : Number) : void {_view.height = height;}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get x() : Number {return _view.x;}
		override public function set x(x : Number) : void {_view.x = x;}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function get y() : Number {return _view.y;}
		override public function set y(y : Number) : void {_view.y = y;}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get scene() : Scene3D {
			return _scene;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get view() : View3D {
			return _view;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get camera() : Camera3D {
			return _camera;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get scaleToScage() : Boolean {
			return _scaleToScage;
		}
		public function set scaleToScage(scaleToScage : Boolean) : void {
			
			_scaleToScage = scaleToScage;
			
			if ( _stage ){
				
				if ( _scaleToScage )
					_stage.addEventListener(Event.RESIZE, onResizeStage , false ,0 , true );
				else
					_stage.removeEventListener( Event.RESIZE, onResizeStage );
				
			}
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get hoverController() : HoverController {
			return _hoverController;
		}
		public function get hoverDrag() : Boolean {
			return _move;
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onMouseWheel(event : MouseEvent) : void {
			
			if ( event.delta > 0 ) {
				
				_cameraOffset += 10;
				 
			} else {
				
				_cameraOffset -= 10;
				
			}

			_hoverController.distance = _cameraOffset;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onResizeStage(event : Event) : void {
			
			_view.width 		= _stage.stageWidth;
			_view.height	 	= _stage.stageHeight;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
 		 */
		private function onMouseDown(event:MouseEvent):void {
			
			if ( ! _stage ) return;
			
			if ( hitTestPoint(_stage.mouseX, _stage.mouseY)){
				
				
				lastPanAngle	 	= _hoverController.panAngle;
				lastTiltAngle 		= _hoverController.tiltAngle;
				lastMouseX 			= _stage.mouseX;
				lastMouseY 			= _stage.mouseY;
				_move 				= true;
				
				_stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				
			}
			
		}	
		/**
		 *  
		 * 
		 * @param
		 * @return
 		 */
		private function onMouseUp(event:MouseEvent):void {
			
			if ( ! _stage ) return;
			_move = false;
			_stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
 		 */
		private function onStageMouseLeave(event:Event):void {
			_move = false;
			_stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onAddedToStage(event : Event) : void {
			
			_stage = stage;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
			initStage();
		}

	}
	
		
}