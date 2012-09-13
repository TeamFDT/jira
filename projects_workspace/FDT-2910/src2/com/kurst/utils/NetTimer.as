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
 
	  getElapsedTime
	  getBPS(loadedBytes)
	  getRTime(loadedBytes, TotalBytes) estimated remaining time until loaded

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
	public class NetTimer {
		private var startSeconds : Number;
		private var startMinutes : Number;
		private var startHours : Number;
		private var startDays : Number ;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function NetTimer() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * return elapsed time in seconds
		 * 
		 * @usage   
		 * @return  
		 */
		public function start() : void {
			var timeObj : Date = new Date();

			startSeconds = timeObj.getSeconds();
			startMinutes = timeObj.getMinutes();
			startHours = timeObj.getHours();
			startDays = timeObj.getDay();
		}

		/**
		 * return elapsed time in seconds
		 * 
		 * @usage   
		 * @return  
		 */
		public function getElapsedTime() : Number {
			var objNewTime : Date = new Date();

			var varElapsedSeconds : Number = objNewTime.getSeconds() - startSeconds;
			var varElapsedMinutes : Number = objNewTime.getMinutes() - startMinutes;
			var varElapsedHours : Number = objNewTime.getHours() - startHours;
			var varElapsedDays : Number = objNewTime.getDay() - startDays;

			return ( varElapsedDays * 24 * 60 * 60 ) + ( varElapsedHours * 60 * 60 ) + ( varElapsedMinutes * 60 ) + varElapsedSeconds;
		}

		/**
		 * returns KBPS
		 * 
		 * @usage   
		 * @param   loadedBytes 
		 * @return  
		 */
		public function getBPS(loadedBytes : Number) : Number {
			return ( Math.round(( loadedBytes / getElapsedTime() / 1024 ) * 10) ) / 10;
		}

		/**
		 * returns remaining time until loaded (only an estimate on current BPS)
		 * 
		 * @usage   
		 * @param   loadedBytes 
		 * @param   TotalBytes  
		 * @return  
		 */
		public function getRemainingTime(loadedBytes : Number, TotalBytes : Number) : Number {
			return Math.round(( TotalBytes - loadedBytes ) / ( this.getBPS(loadedBytes) * 1024 ))	;
		}
	}
}