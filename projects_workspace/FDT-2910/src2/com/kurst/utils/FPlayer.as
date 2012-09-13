/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.utils.player
 * Version 	  	: 1 
 * Description 	: Flash Player Utilities
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 16/06/08 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	static function versionGreaterThan(versionNo:Number):Boolean
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:

	versionGreaterThan(versionNo:Number):Boolean
			trace( player.versionGreaterThan( 1001150 ) );
			trace( player.versionGreaterThan( 901150 ) );// Lowest acceptable capable MP4 player
			trace( player.versionGreaterThan( 801150 ) );

 **********************************************************************************************************************************************************************************/
package com.kurst.utils {
	import flash.system.Capabilities;

	public class FPlayer {
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
		public static function isMovieStar() : Boolean {
			return FPlayer.versionGreaterThan(9, 0, 115, 0);
		}

		/**
		 * @method versionGreaterThan(majorVersion:Number , majorRevision:Number , minorVersion:Number , minorRevision:Number):Boolean
		 * 
		 * @tooltip check is the flashPlayer is equal to or greater than a specified version.
		 * 
		 * @param majorVersion	: Number 
		 * @param majorRevision	: Number 
		 * @param minorVersion	: Number
		 * @param minorRevision	: Number
		 *
		 * @usage: 
		 * 
		import com.kurst.utils.FPlayer
				 
		trace( player.versionGreaterThan( 10,0,1,218 )) 
		trace( player.versionGreaterThan( 9,0,124,0 )) 
		trace( player.versionGreaterThan( 9,0,115,0 )) // MovieStar
		trace( player.versionGreaterThan( 8,0,22,0 )) 
		trace( player.versionGreaterThan( 7,0,25,0 )) 
		trace( player.versionGreaterThan( 5,0,55,0 )) 
		 
		 * @return Boolean
		 */
		public static function versionGreaterThan(majorVersion : Number, majorRevision : Number, minorVersion : Number, minorRevision : Number) : Boolean {
			minorRevision

			var version : String = Capabilities.version

			/**************
			 * 	Notes	
			 **************
			 *	Capabilities.version: 9,0,115,0:
			 *  
			 *		majorVersion 	- 9
			 *		majorRevision 	- 0
			 *		minorVersion 	- 115
			 *		minorRevision 	- 0
			 *		
			 */

			// var osType				: String 			= version.split(' ')[0];

			var versionArray : Array = version.split(' ')[1].split(',');

			var majorVersion_c : Number = Number(versionArray[0]);
			var	majorRevision_c : Number = Number(versionArray[1]);
			var	minorVersion_c : Number = Number(versionArray[2]);
			// var	minorRevision_c		: Number 			= Number ( versionArray[3] );

			if ( majorVersion_c >= majorVersion ) {
				if ( majorVersion_c > majorVersion ) {
					return true;
				} else {
					if ( majorRevision_c >= majorRevision ) {
						if ( minorVersion_c >= minorVersion ) {
							return true;
						} else {
							return false;
						}
					} else {
						return false;
					}
				}
			} else {
				return false;
			}
		}

		/**
		 * @method  
		 * @tooltip 
		 * @param
		 * @param
		 * @return 
		 */
		public static function getPlatform() : String {
			var version : String = Capabilities.version
			return String(version.split(' ')[0]).toUpperCase();
		}
	}
}