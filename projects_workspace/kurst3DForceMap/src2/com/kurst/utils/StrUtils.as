/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.utils.strUtils
 * Version 	  	: 1
 * Description 	: String Utilities
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 03/01/08
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 		normalizeChar( str:String, char:String ):String
 * 		replaceChar( str:String, charToRemove:String , charToReplace:String):String
 * 		trashReturns ( val:String , charToReplace:String = " ") :String
 * 		toInitialCap(sOriginal:String)
 * 		capitalizeName(sOriginal:String, checkPrefixFlag:Boolean = true):String
 * 		trim(sOriginal:String):String
 * 		convertString ( value, type  ):Object
 * 		isNumeric(p_string:String):Boolean 
 * 
 ********************************************************************************************************************************************************************************
 * TODO			:
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.utils {
	import com.adobe.serialization.json.JSON;

	public class StrUtils {
		function StrUtils() {
		}

		// -STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// SSSSS TTTTTT   AAA   TTTTTT IIIIII  CCCCC
		// SS       TT    AAAAA    TT     II   CC   CC
		// SSSS    TT   AA   AA   TT     II   CC
		// SS   TT   AAAAAAA   TT     II   CC   CC
		// SSSSS    TT   AA   AA   TT   IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * 15 July 2006
		 * 
		 * @usage   remove leading, trailing and double characters from anywhere in string,
		 * 
		 * 				strUtils.normalizeChar( "abc,,,,,def,,g,", "," ); // abc,def,g
		 * 				strUtils.normalizeChar( ",,a,b,c, , , , ,d, ,g,", "," );//a,b,c, , , , ,d, ,g
		 * 				strUtils.normalizeChar( "b,aaa,b,aaa,b,aaa,b,aaa,b,aaa,b,aaa,b", "a" );//b,a,b,a,b,a,b,a,b,a,b,a,b
		 * 
		 * @param   str string to be processed and returned
		 * @param   char character to be normalized
		 * 
		 * @return  modified string

		 */
		public static function normalizeChar(str : String, char : String) : String {
			if ( str == "" ) return "";

			var strCleaned : Boolean = true;
			var cpos : Number = 0;

			if ( str.indexOf(char) != -1  ) {
				while ( strCleaned ) {
					var chkpos : Number = str.indexOf(char, cpos);

					if ( chkpos == -1 ) {
						strCleaned = false
					} else {
						if ( str.charAt(chkpos + 1) == char  ) {
							str = str.slice(0, chkpos) + str.slice(chkpos + 1, str.length)
						} else {
							if ( chkpos != -1 ) {
								cpos = chkpos + 1;
							} else {
								cpos++;
							}
						}
					}

					if ( ( cpos == str.length ) || ( cpos == -1 ) ) {
						strCleaned = false
					}
				}
				// ----------------------------------
				// clean at end of run
				if ( str.charAt(str.length - 1) == char ) {
					str = str.slice(0, str.length - 1)
				}

				if ( str.charAt(0) == char ) {
					str = str.slice(1, str.length)
				}
			}

			return str;
		}

		/**
		 * replace occurences of a character in a string
		 * 
		 * @usage   
		 * 
		 * 			strUtils.replaceChar( "b,aaa,b,aaa,b,aaa,b,aaa,b,aaa,b,aaa,b", "a" , "b")//b,bbb,b,bbb,b,bbb,b,bbb,b,bbb,b,bbb,b
		 * 
		 * @param   str           
		 * @param   charToRemove  
		 * @param   charToReplace 
		 * 
		 * @return  modified string
		 */
		public static function replaceChar(str : String, charToRemove : String, charToReplace : String) : String {
			var temparray : Array = str.split(charToRemove);
			return temparray.join(charToReplace);
		}

		/**
		 * stripTags(myString:String, startTag:String='<', endTag:String='>'):String
		 * 
		 * @usage   
		 * @param   myString
		 * @param   startTag
		 * @param   endTag 
		 * @return  String
		 */
		public static function stripTags(myString : String, startTag : String = '<', endTag : String = '>') : String {
			var istart : Number

			if ( ( myString.indexOf(startTag) != -1 ) && ( myString.indexOf(endTag) != -1 ) ) {
				while ( ( istart = myString.indexOf(startTag) ) != -1 )
					myString = myString.split(myString.substr(istart, myString.indexOf(endTag) - istart + 1)).join("");
			}

			return myString;
		}

		/**
		 * remove carriage returns from a string
		 * 
		 * 	strUtils.trashReturns( "b\raaa,b,aaa,b,aaa\r,b,aa\ra,b,aaa,b,a\raa,b") // * 
		 * @usage   
		 * @param   val 
		 * @return  
		 */
		public static function trashReturns(val : String, charToReplace : String = " ") : String {
			return replaceChar(val, "\r", charToReplace) ;
		}

		/**
		 * Capitalize first character of a string
		 * 
		 * @usage   
		 * toInitialCap("aname")
		 * 		
		 * @param   string
		 * @return  string
		 */
		public static function toInitialCap(sOriginal : String) : String {
			return sOriginal.charAt(0).toUpperCase() + sOriginal.substr(1).toLowerCase();
		}

		/**
		 * Capitalize a name. Include check for prefixes, and capitalize them accordingly. 
		 * 
		 * @usage   capitalizeName("o'rilley");
		 * 
		strUtils.capitalizeName( "MacDonald" ) 
		strUtils.capitalizeName( "Macplonker" ) 
		strUtils.capitalizeName( "maczwen" )
		strUtils.capitalizeName( "McQueen" ) 
		strUtils.capitalizeName( "mcflurry" )

		 * @param   string
		 * @param   checkPrefixFlag 
		 * @return  modified string
		 */
		private static var namePrefixes : Array = ["Mc", "Mac", "O'", "de "]

		public static function capitalizeName(sOriginal : String, checkPrefixFlag : Boolean = true) : String {
			if ( checkPrefixFlag ) {
				sOriginal = sOriginal.toLowerCase();

				for ( var i:String in namePrefixes ) {
					var prefix : String = namePrefixes[i]

					if ( sOriginal.substr(0, prefix.length) == prefix.toLowerCase() ) {
						return prefix + toInitialCap(sOriginal.substr(prefix.length, sOriginal.length));
					}
				}

				return toInitialCap(sOriginal);
			}

			return toInitialCap(sOriginal);
		}

		/**
		 * remove whitespace elements from the beginning and end of a string
		 * 
		 * @usage   strUtils.trim ( "   a string that needs trimming  . " );
		 * @param   sOriginal - the string to strim
		 * @return  string
		 */
		public static function trim(sOriginal : String) : String {
			// Split the string into an array of characters.
			var aCharacters : Array = sOriginal.split("");

			// Remove any whitespace elements from the beginning of the array using
			// splice(). Use a break statement to exit the loop when you reach a
			// non-whitespace character to prevent it from removing whitespace
			// in the middle of the string.

			for (var i : Number = 0; i < aCharacters.length; i++) {
				if ( aCharacters[i] == "\r" || aCharacters[i] == "\n" || aCharacters[i] == "\f" || aCharacters[i] == "\t" || aCharacters[i] == " ") {
					aCharacters.splice(i, 1);
					i--;
				} else {
					break;
				}
			}

			// Loop backward through the removing whitespace elements until a
			// non-whitespace character is encountered. Then break out of the loop.
			for (var j : Number = aCharacters.length - 1; j >= 0; j--) {
				if (aCharacters[j] == "\r" || aCharacters[j] == "\n" || aCharacters[j] == "\f" || aCharacters[j] == "\t" || aCharacters[j] == " ") {
					aCharacters.splice(j, 1);
				} else {
					break;
				}
			}

			// Recreate the string with the join() method and return the result.
			return aCharacters.join("");
		}

		/**
		 * Enter description here
		 * 
		 * @usage  strUtils.convertString( "1", "number" );
		 * @param   value to be converted
		 * @param   type - boolean || string || number || array "1,2,3,4,5,6" || JSON || Date
		 * @return  number // boolean // string
		 */
		public static function convertString(value : *, type : String) : Object {
			var val : String = value.toLowerCase()

			switch ( type.toLowerCase() ) {
				case "boolean":
					var returnVal : Boolean
					switch ( val ) {
						case "1":
							returnVal = true;
							break;
						case "0":
							returnVal = false;
							break;
						case "true":
							returnVal = true;
							break;
						case "false":
							returnVal = false;
							break;
						default :
							return value;
							break;
					}
					return returnVal;
					break;
				case "json":
					if ( value == '' )
						return null;
					else
						return com.adobe.serialization.json.JSON.decode(value)
				case "string":
					return String(value);
					break ;
				case "array":
					if ( String(value) == '' )
						return new Array();
					else
						return value.split(",");
					break;
				case "number":
					var tmpNumber : Number = Number(value) ;
					if ( isNaN(tmpNumber) ) {
						return value;
					} else {
						return tmpNumber;
					}
					break;
				case "date":
					if ( val == '' )
						return new Date();
					return DateUtils.convertPixelPostDate(val);
					break;
				default:
					return value;
					break;
			}
		}

		/** 
		 *	Determines whether the specified string is numeric. CREDITS: GSkinner.com
		 *
		 *	@param p_string The string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isNumeric(p_string : String) : Boolean {
			if (p_string == null) {
				return false;
			}
			var regx : RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		public static function contains(string : String, char : String) : Boolean {
			return !( string.indexOf(char) == -1 );
		}

		public static function extractURL(str : String) : String {
			var result : String = null;
			var pos : int = str.indexOf('http://');
			var endPos : int

			if ( pos != -1 ) {
				endPos = str.indexOf(' ', pos);
				endPos = ( endPos == -1 ) ? str.length : endPos ;
				result = str.substr(pos, endPos - pos);
			}

			return result;
		}
	}
}
