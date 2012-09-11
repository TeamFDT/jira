/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.utils.TimeUtils
 * Version 	  	: 1
 * Description 	: time formatting / time / date utilities
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti 
 * Date 			: 26/08/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 		secToHMS ( nbOfSec:Number , delimiter:String = ":") : String	- seconds to Hours:Minutes:Seconds  
 * 		secToMS ( nbOfSec:Number , delimiter:String = ":") : String		- seconds to Minutes:Seconds
 * 		convertMS ( ms:Number, datepart:String = "y" ) : Number
 *
 ********************************************************************************************************************************************************************************
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.utils {
	public class TimeUtils {
		/**
		 * @method secToHMS ( nbOfSec:Number , delimiter:String = ":") : String 
		 * @tooltip 
		 * @param
		 * @param
		 * @return time formated string from seconds '12:34:23',
		 */
		static public function secToHMS(nbOfSec : Number, delimiter : String = ":") : String {
			var seconds : Number = nbOfSec % 60;
			var minutes : Number = Math.floor(nbOfSec / 60) % 60;
			var hours : Number = Math.floor(nbOfSec / (60 * 60)) % 24;
			var days : Number = Math.floor(nbOfSec / (60 * 60 * 24));

			var seconds_str : String
			var minutes_str : String
			var hours_str : String

			seconds_str = ( seconds <= 9.49 ) ? "0" + String(Math.round(seconds)) : String(Math.round(seconds));
			minutes_str = ( minutes < 10 ) ? "0" + String(minutes) : String(minutes);
			hours = ( ( days * 24 ) + hours ) ;
			// ( hours < 10 ) ? "0" + String ( hours ) : hours ;
			hours_str = ( hours < 10 ) ? "0" + String(hours) : String(hours);

			return String(hours_str + delimiter + minutes_str + delimiter + seconds_str);
		}

		/**
		 * @method secToMS ( nbOfSec:Number , delimiter:String = ":") : String 
		 * @tooltip 
		 * @param
		 * @param
		 * @return time formated string from seconds '34:23',
		 */
		static public function secToMS(nbOfSec : Number, delimiter : String = ":") : String {
			var seconds : Number = nbOfSec % 60;
			var minutes : Number = Math.floor(nbOfSec / 60) % 60;
			var hours : Number = Math.floor(nbOfSec / (60 * 60)) % 24;
			var days : Number = Math.floor(nbOfSec / (60 * 60 * 24));

			minutes += ( ( days * 24 ) + hours ) * 60;

			var seconds_str : String
			var minutes_str : String
			// var hours_str	:String

			seconds_str = ( seconds <= 9.49 ) ? "0" + String(Math.round(seconds)) : String(Math.round(seconds));
			minutes_str = ( minutes < 10 ) ? "0" + String(minutes) : String(minutes);

			return String(minutes_str + delimiter + seconds_str);
		}

		/**
		 * @method convertMS ( ms:Number, datepart:String = "y" )
		 * @tooltip conver miliseconds into 	YEARS 	- y
		 * 									MONTH 	- m
		 * 									DAY 	- d
		 * 									HOURS 	- h
		 * 									MINUTES - n
		 * 									SECONDS - s
		 * @param
		 * @param
		 * @return 
		 */
		static public function convertMS(ms : Number, datepart : String = "y") : Number {
			var millisecondsBtwDates : Number = ms
			var secondsBtwDates : Number = Math.floor(millisecondsBtwDates / 1000);
			var minutesBtwDates : Number = Math.floor(secondsBtwDates / 60);
			var hoursBtwDates : Number = Math.floor(minutesBtwDates / 60);
			var daysBtwDates : Number = Math.floor(hoursBtwDates / 24);
			var yearsBtwDates : Number = Math.floor(daysBtwDates / 365);
			var monthsBtwDates : Number = Math.floor(daysBtwDates / 365 * 12);
			var returnVar : Number = (datepart == "y") ? yearsBtwDates : (datepart == "m") ? monthsBtwDates : (datepart == "d") ? daysBtwDates : (datepart == "h") ? hoursBtwDates : (datepart == "n") ? minutesBtwDates : (datepart == "s") ? secondsBtwDates : millisecondsBtwDates;

			return returnVar;
		};
	}
}

