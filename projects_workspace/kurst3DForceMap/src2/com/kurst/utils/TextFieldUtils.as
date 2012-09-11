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
package com.kurst.utils {
	import flash.text.TextFormat;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextField;

	import com.kurst.data.TextFieldDataItem;

	public class TextFieldUtils {
		private static var _inst : TextFieldUtils

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public static function addHTMLRollOver(txt : TextField, callback : Function, scope : Object) : void {
			getInstance()._addTextField(txt, callback, scope);
		}

		public static function removeHTMLRollOver(txt : TextField) : Boolean {
			return getInstance()._removeTextField(txt);
		}

		public static function getInstance() : TextFieldUtils {
			if ( _inst == null ) _inst = new TextFieldUtils();
			return _inst;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var tfArray : Array
		private var timer : Timer
		private var delay : Number = 250

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TextFieldUtils() {
			tfArray = new Array()
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, tick, false, 0, true);
		}

		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  RRRRR   IIIIII V     V   AAA   TTTTTT EEEEEEE
		// PP   PP RR  RR    II   V     V  AAAAA    TT   EE
		// PPPPPP  RRRRR     II    V   V  AA   AA   TT   EEEE
		// PP      RR  RR    II     V V   AAAAAAA   TT   EE
		// PP      RR   RR IIIIII    V    AA   AA   TT   EEEEEEE
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function stopTimer() : void {
			timer.stop();
		}

		private function startTimer() : void {
			timer.start();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function detectMouseOver(dataItem : TextFieldDataItem) : void {
			var txt : TextField = dataItem.txt;
			var fnc : Function = dataItem.callback;
			var scope : Object = dataItem.scope;

			var index : Number = txt.getCharIndexAtPoint(txt.mouseX, txt.mouseY);
			var url : String = "";

			if (index > 0) {
				var fmt : TextFormat = txt.getTextFormat(index, index + 1);
				if (fmt.url) url = fmt.url;
			}

			dataItem.href = url;

			// trace ( txt.hitTestPoint(txt.mouseX, txt.mouseY))

			if ( ( 	url.length > 0 ) && ( !dataItem.overFlag ) ) {
				dataItem.overFlag = true;
				fnc.apply(scope, [dataItem]);
			} else if ( ( 	url.length == 0 && dataItem.overFlag ) ) {
				/*
				} else if ( ( 	url.length == 0 && dataItem.overFlag ) 
				|| ( ( txt.mouseY > ( txt.y + txt.height ) ) && dataItem.overFlag ) ) { 
				trace( txt.height );
				 */

				dataItem.overFlag = false;
				fnc.apply(scope, [dataItem]);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function _addTextField(txt : TextField, callback : Function, scope : Object) : void {
			var dataItem : TextFieldDataItem = new TextFieldDataItem();

			dataItem.txt = txt;
			dataItem.callback = callback;
			dataItem.scope = scope;
			dataItem.overFlag = false;

			tfArray.push(dataItem);

			startTimer();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function _removeTextField(txt : TextField) : Boolean {
			var dataItem : TextFieldDataItem
			var result : Boolean = false;
			for ( var c : int = 0 ; c < tfArray.length ; c++ ) {
				dataItem = tfArray[c] as TextFieldDataItem;

				if ( dataItem.txt == txt ) {
					dataItem.callback = null
					dataItem.txt = null;
					dataItem.scope = null;
					dataItem.href = null;
					// dataItem.overFlag	= NaN;

					tfArray.splice(c, 1);

					result = true;
				}
			}

			if ( tfArray.length == 0 ) stopTimer();

			return result;
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
		/** timer tick - run mouse over detection
		 * @method tick(event : TimerEvent)
		 * @param
		 * @return
		 */
		private function tick(event : TimerEvent) : void {
			/* Test
			if ( tfArray.length == 1 ){
				
			var d : TextFieldDataItem = tfArray[0] as TextFieldDataItem;
			trace('tick: ' + d.txt.text );
				
			} else {
			trace('tick: ' + tfArray.length )
			}
			 */
			// var dataItem : TextFieldDataItem

			for ( var c : int = 0 ; c < tfArray.length ; c++ )
				detectMouseOver(tfArray[c] as TextFieldDataItem);

			if ( tfArray.length == 0 ) stopTimer();
		}
	}
}

