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
package com.kurst.controls.core {
	import flash.display.Sprite;

	public class KurstUIComponentBase extends Sprite {
		
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected var _width 	: Number;
		protected var _height 	: Number;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function KurstUIComponentBase() {
			super();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function setSize(w : Number, h : Number) : void {
			
			_width = w;
			_height = h;

			draw();
		}
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		public function move(xm : Number, ym : Number) : void {
			x = xm;
			y = ym;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		protected function draw() : void {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		override public function get width() : Number {
			return _width;
		}
		override public function set width(w : Number) : void {
			_width = w;
			draw();
		}
		/**
		 * @method 
		 * @tooltip
		 * @param
		 * @return
		 */
		override public function get height() : Number {
			return _height;
		}
		override public function set height(h : Number) : void {
			_height = h;
			draw();
		}
		
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	}
}