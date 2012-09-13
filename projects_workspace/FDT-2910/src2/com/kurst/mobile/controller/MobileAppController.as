/********************************************************************************************************************************************************************************
* 
* Class Name  	: 
* Version 	  	: 
* Description 	: 
* 
********************************************************************************************************************************************************************************
* 
* Author 		: 
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
* NOTES			: -default-background-color #000000
**********************************************************************************************************************************************************************************/
package com.kurst.mobile.controller {
	import com.kurst.events.MobileAppControllerEvent;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;


	public class MobileAppController extends EventDispatcher {
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static var inst : MobileAppController ;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		public static function init( s : Stage ) : MobileAppController {
			
			getInstance().init( s );
			return getInstance();
			
		}
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		public static function getInstance() : MobileAppController {
			
			if ( inst == null ) {
				
				inst = new MobileAppController();
				
			}
			
			return inst;
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _appActive		: Boolean 	= false;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var stage 					: Stage ;
		private var activateTimer			: Timer;
		private var sprite					: Sprite;
		private var initialActivate			: Boolean = false;
		

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function MobileAppController() : void {
			
			sprite = new Sprite();
			
			activateTimer = new Timer( 100 );
			activateTimer.addEventListener(TimerEvent.TIMER, onActivateTimer , false ,0 ,true );
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
			
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function init( s : Stage ) : void {
					
			stage = s;
			stage.addChild( sprite );
			
			//stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange , false ,0 , true );
		   	NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE , 		handleActivate , 	false , 0 , true );
		   	NativeApplication.nativeApplication.addEventListener( Event.DEACTIVATE , 		handleDeactivate , 	false , 0 , true );
			
		   	stage.addEventListener( KeyboardEvent.KEY_DOWN , 	onKeyPress , 		false , 0 , true );
			
		}
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function deActivate() : void {
			
			dispatchEvent( new MobileAppControllerEvent( MobileAppControllerEvent.DEACTIVATE_APP , false , false ) );
			_appActive = false;
						
		}
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function activate() : void {
			
			dispatchEvent( new MobileAppControllerEvent( MobileAppControllerEvent.ACTIVATE_APP , false , false ) );
			
			_appActive = true;
			initialActivate = true;
						
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		public function get appActive() : Boolean {
			return _appActive;
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function handleDeactivate(event : Event) : void {
			
			if ( initialActivate ){
				
				deActivate();
				
			}
			
		}

		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function handleActivate(event : Event) : void {
					
			if ( initialActivate ) {
				
				activate();
				
			} else if ( ! _appActive && ! initialActivate ){
				
				activateTimer.start();
				
			}
			
		}
		
		//------------------------------------------------------------------------------------------------


		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function onActivateTimer(event : TimerEvent) : void {
			
			activateTimer.stop();
			activate();
			
		}
		
		//------------------------------------------------------------------------------------------------
		
		/**
		* @method 
		* @tooltip
		* @param
		* @return
		*/
		private function onKeyPress(event : KeyboardEvent) : void {

            switch(event.keyCode) {
				
                case Keyboard.BACK: // user hit the back button on Android device
                
					//trace('goBack');
	                // case 94: // was hard-coded for older build of SDK supporting eclair
					
					// Prevent back quit Android
                    //event.preventDefault();
					//event.stopImmediatePropagation();

                    break;
					
                }
				
          }
		  
		




	}
	
		
}