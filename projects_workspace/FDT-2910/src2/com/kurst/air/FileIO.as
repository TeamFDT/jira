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
package com.kurst.air {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileIO {
		private var fStream : FileStream

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function FileIO() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 *  writeTextFile( file : File , str : String ) : void
		 *  
		 *  save a text file to disk
		 * 
		 * @param file : File - file to save
		 * @param str : String - content / text data
		 */
		public function writeTextFile(file : File, str : String) : void {
			
			fStream = new FileStream();
			fStream.open(file, FileMode.WRITE);
			fStream.writeUTFBytes(str);
			fStream.close();
			fStream = null;
			
		}
		/**
		 * writeBinaryFile( file : File , byteArray : ByteArray ) : void
		 *  
		 * save a binary file to disk
		 * 
		 * @param file : File - file to save
		 * @param byteArray : ByteArray  - file content
		 */
		public function writeBinaryFile(file : File, byteArray : ByteArray) : void {
			
			fStream = new FileStream();
			fStream.open(file, FileMode.WRITE);
			fStream.writeBytes(byteArray);
			fStream.close();
			fStream = null;
			
		}
		/**
		 * readTextFile( file : File ): String
		 * 
		 * read a text file 
		 * 
		 * @param file : File - file to read
		 * @return String / File Content
		 */
		public function readTextFile(file : File) : String {
			
			fStream = new FileStream();
			fStream.open(file, FileMode.READ);

			var str : String = fStream.readUTFBytes(fStream.bytesAvailable);
			fStream.close();

			return str;
		}
		/**
		 * readBinaryFile( file : File ): ByteArray
		 * 
		 * read content of a binary file 
		 * 
		 * @param file : File - file to read
		 * @return ByteArray / File content
		 */
		public function readBinaryFile(file : File) : ByteArray {
			
			fStream = new FileStream();
			fStream.open(file, FileMode.READ);

			var ba : ByteArray = new ByteArray();

			fStream.readBytes(ba)
			fStream.close();

			return ba;
		}
		
	}
}