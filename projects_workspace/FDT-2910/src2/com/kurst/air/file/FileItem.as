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
package com.kurst.air.file {
	import com.kurst.events.CEventDispatcher;
	import com.kurst.events.FileUtilsEvent;

	import flash.events.Event;
	import flash.filesystem.File;

	public class FileItem extends CEventDispatcher {
		private var _source : File
		private var _target : File
		private var dest : File;
		private var _copyFlag : Boolean;
		private var _queueID : Number;
		private var _ID : Number;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function FileItem(file : File = null) {
			super();

			if ( file != null )
				source = file;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			dest.removeEventListener(Event.COMPLETE, FileCopyComplete);

			_source = null
			_target = null
			dest = null
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function copy(overwrite : Boolean = false) : void {
			dest = new File(target.nativePath + '/' + source.name);

			source.addEventListener(Event.COMPLETE, FileCopyComplete, false, 0, true);

			try {
				if ( !source.isDirectory )
					source.copyToAsync(dest, overwrite);
			} catch ( e : Error ) {
				trace("Error:", e.message);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function FileCopyComplete(e : Event) : void {
			dest.removeEventListener(Event.COMPLETE, FileCopyComplete);

			var fie : FileUtilsEvent = new FileUtilsEvent(FileUtilsEvent.FILE_ITEM_OPERATION_COMPLETE, true);
			fie.ID = ID;
			fie.queueID = queueID;
			fie.file = new File(dest.nativePath);

			dispatchEvent(fie);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get source() : File {
			return _source;
		}

		public function set source(source : File) : void {
			_source = source;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get target() : File {
			return _target;
		}

		public function set target(target : File) : void {
			_target = target;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get queueID() : Number {
			return _queueID;
		}

		public function set queueID(queueID : Number) : void {
			_queueID = queueID;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get ID() : Number {
			return _ID;
		}

		public function set ID(a : Number) : void {
			_ID = a;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get copyInProgess() : Boolean {
			return _copyFlag;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */	

		
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}