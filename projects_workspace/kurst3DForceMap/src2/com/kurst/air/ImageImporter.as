/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.air.ImageImporter
 * Version 	  	: 1
 * Description 	: Import and resize large images into a target directory 
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
 * 		processFileArray( iArray : Array ) : void
 *		stopImport() : void 
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
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import ru.inspirit.utils.JPGEncoder;

	import com.kurst.air.data.ImageDataItem;
	import com.kurst.air.utils.ImageInfo;
	import com.kurst.events.FileUtilsEvent;
	import com.kurst.events.ImageImporterEvent;
	import com.kurst.events.eventDispatcher;
	import com.kurst.utils.FDelayCall;
	import com.kurst.utils.LocationUtil;
	import com.kurst.utils.MovieUtils;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.ByteArray;

	// import com.adobe.images.JPGEncoder
	public class ImageImporter extends eventDispatcher {
		public static const IDLE : int = 0;
		public static const COPYING : int = 1;
		public static const ENCODING : int = 2;
		public static const COMPLETE : int = 3;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		[Bindable]
		public var fileDataArray : ArrayCollection;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var fileIO : FileIO = new FileIO();
		private var fileUtils : FileUtils = new FileUtils();
		private var rBulkLoader : BulkLoader
		private var fileProcessedArray : Array;
		private var encodefileDataArrayIndex : int;
		private var jpgEncoderBusy : Boolean = false;
		private var importerStoppedFlag : Boolean = true;
		// private var debug						: Boolean		= true;
		// private var counter						: int			= 0;
		private var jpgGEncoder : JPGEncoder
		private var pngExtension : String = 'png'
		private var jpgExtension : String = 'jpg'
		private var _subFolderName : String = 'temp';
		private var _baseFolder : File = File.applicationStorageDirectory;
		private var _quality : int = 99;
		private var _maxSize : int = 511;
		private var _progress : int = 0;
		private var _total : int = 0;
		private var _status : String = 'Idle';
		private var _statusMessages : Array = ['Idle', 'Copying Images', 'Encoding Resized Images', 'Complete'];
		private var imageInfo : ImageInfo

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function ImageImporter() {
			deleteTempFolder();

			fileDataArray = new ArrayCollection();
			imageInfo = new ImageInfo();
			// imageInfo			= new ImageInfo();

			fileUtils = new FileUtils();
			fileUtils.addEventListener(FileUtilsEvent.COPY_COMPLETE, CopyFilesComplete, false, 0, true);
			fileUtils.addEventListener(FileUtilsEvent.COPY_PROGRESS, CopyProgress, false, 0, true);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/** Process an array of Files ( flash.filesystem.File ) - This will be batched / resized and copied to a specified directory
		 * 
		 * @method 	processFileArray( iArray : Array ) : void
		 * 
		 * @param	fileArray		: Array		- Array of files to batch
		 * 
		 */
		public function processFileArray(fileArray : Array) : void {
			importerStoppedFlag = true;

			stopAllCurrentProcesses();
			deleteTempFolder();
			deleteProcessedArray();

			FDelayCall.addCall(_processFileArray, this, fileArray);
			//
		}

		/** Stop any current import operation
		 * 
		 * @method stopImport() : void 
		 * 
		 */
		public function stopImport() : void {
			stopAllCurrentProcesses();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/** Procedd an array of files
		 * 
		 * @method _processFileArray( iArray : Array ) : void
		 * 
		 * @param	fileArray		: Array		- Array of files to batch
		 * 
		 */
		private function _processFileArray(iArray : Array) : void {
			importerStoppedFlag = false;

			initLoader();
			initJPGEncoder();

			processImages(iArray);
			createTempFolder();
			copyImagesToTempFolder();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/** Copy all images that do not need to be resized to the target folder
		 *  
		 * @method copyImagesToTempFolder() : void
		 * 
		 */
		private function copyImagesToTempFolder() : void {
			var copyArray : Array = new Array();
			var dataItem : ImageDataItem

			for ( var c : int = 0 ; c < fileDataArray.length ; c++ ) {
				dataItem = fileDataArray.getItemAt(c) as ImageDataItem;

				if ( !dataItem.resize )
					copyArray.push(dataItem.file);
			}

			if ( copyArray.length > 0 ) {
				setStatus(ImageImporter.COPYING)
				fileUtils.copyFileArrayToFolder(copyArray, getTempFolder(), true);
			} else {
				loadImagesToBeResized();
			}
			// if no images are in copy queue array - start resizing
		}

		/** Process all images sort the ones that need to be resized from the ones that just need to be copied
		 * 
		 * @method processImages( imageArray : Array ) : void
		 * 
		 * @param	imageArray		: Array		- Array of files to batch
		 */
		private function processImages(imageArray : Array) : void {
			var imageDim : Object;
			var dataItem : ImageDataItem;

			for ( var c : int = 0 ; c < imageArray.length ; c++ ) {
				dataItem = new ImageDataItem();
				// Image Data Item
				dataItem.file = imageArray[c] as File;
				// Reference file
				dataItem.url = ( LocationUtil.isMac() ) ? 'file://' + dataItem.file.nativePath : dataItem.file.nativePath ;
				;
				// URI of file

				imageDim = readImageInfo(dataItem.file);
				// ( dataItem.file.extension.toLocaleLowerCase() == pngExtension ) ? ImageUtils.readPNGDim( dataItem.file ) : ImageUtils.readJPGDim( dataItem.file ); // Read Image Dimensions ( width / height )

				if ( imageDim != -1 ) {
					if ( imageDim.width > _maxSize || imageDim.height > _maxSize )
						dataItem.resize = true;
					// if image is too large flag it as needing to be resized
				}

				fileDataArray.addItem(dataItem);
				// add item to data array
			}

			total = fileDataArray.length;
			// total files in process

			// Sort array by resize
			var d : SortField = new SortField()
			d.name = 'resize'
			d.numeric = true;

			var s : Sort = new Sort()
			s.fields = [d];

			fileDataArray.sort = s;
			fileDataArray.refresh();
		}

		private function readImageInfo(f : File) : Object {
			var ba : ByteArray = new ByteArray();
			var stream : FileStream = new FileStream();
			var result : Object = new Object();

			stream.open(f, FileMode.READ);
			stream.readBytes(ba);
			stream.close();

			if ( !imageInfo.checkType(ba) )
				return -1;

			result.width = imageInfo.width
			result.height = imageInfo.height

			return result;
		}

		/** Load all images that need to be resized
		 *  
		 * @method loadImagesToBeResized() : void 
		 */
		private function loadImagesToBeResized() : void {
			if ( rBulkLoader == null ) initLoader();

			var imagesToResize : int = 0;
			var imageDataItem : ImageDataItem

			for ( var c : int = 0 ; c < fileDataArray.length ; c++ ) {
				imageDataItem = fileDataArray.getItemAt(c) as ImageDataItem;

				if ( imageDataItem.resize ) {
					// if the file needs resizing

					// var f 		: File 			= imageDataItem.file;
					// var uri		: String 		= imageDataItem.url;

					// add it to the loader
					var lItem : LoadingItem = rBulkLoader.add(imageDataItem.url);
					lItem.addEventListener(Event.COMPLETE, ImageLoaded, false, 0, true);

					imagesToResize++;
				}
			}

			if ( imagesToResize == 0 ) {
				importComplete();
				// if no files need resizing - then import is complete
			} else {
				rBulkLoader.start();
			}
			// start loading files
		}

		/** Encode the next file in the queue
		 * 
		 * @method encodeNextFile() : Boolean
		 * @return false is encode queue is finished / true is encode queue is processing
		 */
		private function encodeNextFile() : Boolean {
			if ( importerStoppedFlag ) return false;
			if ( jpgEncoderBusy ) return false;

			var result : Boolean = true;
			var nextRecord : ImageDataItem;
			var nextRecordFound : Boolean = false;

			// FIND NEXT IMAGE TO ENCODE
			for ( var c : int = 0 ; c < fileDataArray.length ; c++ ) {
				var imgData : ImageDataItem = fileDataArray.getItemAt(c) as ImageDataItem;

				if ( imgData.bitmapData != null && !imgData.processed && !nextRecordFound ) {
					nextRecordFound = true;
					imgData.processed = true;
					nextRecord = imgData;
					encodefileDataArrayIndex = c;
				}
			}

			if ( nextRecordFound ) {
				setStatus(ImageImporter.ENCODING)

				jpgEncoderBusy = true;
				jpgGEncoder.encodeAsync(nextRecord.bitmapData)
				result = true;
			} else {
				importComplete();
				stopAllCurrentProcesses();

				jpgEncoderBusy = false;
				result = false;
			}

			return result;
		}

		/** Calculate the resize ratio of the bitmap ( to fit within max size )

		 * 
		 * @method 	calcResizeRatio( b : Bitmap ) : Number
		 * @param 	b	: Bitmap - source bitmap to be resized  
		 * @return  Numner - ratio / percentage that image needs to be resized to fit within _maxSize
		 */
		private function calcResizeRatio(b : Bitmap) : Number {
			var hRatio : Number = _maxSize / b.height;
			var wRatio : Number = _maxSize / b.width;

			return ( hRatio > wRatio ) ? wRatio : hRatio ;
		}

		/** Update Encoder status
		 * 
		 * @method setStatus( id : int ) : void
		 * @param 	id : int - status ID:
		 * 
		IDLE				: int			= 0;
		COPYING				: int			= 1;
		ENCODING			: int			= 2;
		COMPLETE			: int			= 3;

		 */
		private function setStatus(id : int) : void {
			status = _statusMessages[id];
			dispatchEvent(new ImageImporterEvent(ImageImporterEvent.STATUS_UPDATE));
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// PROGRESS
		/**
		 * 
		 * @method updateProgress( imageDataItem : ImageDataItem = null ) : void
		 * @param
		 */
		private function updateProgress(imageDataItem : ImageDataItem = null) : void {
			progress++;

			var e : ImageImporterEvent = new ImageImporterEvent(ImageImporterEvent.PROGRESS)
			e.total = total;
			e.progress = progress;
			e.imageData = imageDataItem;
			dispatchEvent(e);
		}

		/**
		 * @method importComplete() : void
		 * @return
		 */
		private function importComplete() : void {
			setStatus(ImageImporter.IDLE);

			var e : ImageImporterEvent = new ImageImporterEvent(ImageImporterEvent.COMPLETE)
			e.total = total;
			e.progress = progress;
			e.fileArray = fileProcessedArray;
			dispatchEvent(e);
		}

		/**
		 * 
		 * @method updateCopiedFileStatus( newFile : File ) : void 
		 * @param
		 */
		private function updateCopiedFileStatus(newFile : File) : void {
			var img : ImageDataItem = getImageDataItemByProp('filename', newFile.name)
			// fileDataArray.getItemAt(c) as ImageDataItem;
			img.processed = true;

			fileProcessedArray.push(newFile);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// DATA
		/**
		 * 
		 * @method getImageDataItemByProp( property : String , value : * ) : ImageDataItem
		 * @param
		 * @return
		 */
		private function getImageDataItemByProp(property : String, value : *) : ImageDataItem {
			var result : ImageDataItem;

			for ( var c : int = 0 ; c < fileDataArray.length ; c++ ) {
				var img : ImageDataItem = fileDataArray.getItemAt(c) as ImageDataItem

				if ( MovieUtils.functionExists(img, property) ) {
					if ( value == img[property] )
						result = img;
				}
			}

			return result;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Temp Folder
		/**
		 * 
		 *  
		 * @method deleteTempFolder() : void 
		 */
		private function deleteTempFolder() : void {
			var f : File = _baseFolder.resolvePath(subFolderName);

			if ( f.exists )
				f.deleteDirectory(true);
		}

		/**
		 * 
		 * @method getTempFolder() : File
		 * @return
		 */
		private function getTempFolder() : File {
			return _baseFolder.resolvePath(subFolderName);
		}

		/**
		 * 
		 * 
		 * @method createTempFolder() : void
		 */
		private function createTempFolder() : void {
			if ( !getTempFolder().exists )
				getTempFolder().createDirectory();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// CLEAN UP;
		/**
		 * 
		 * 
		 * @method deleteProcessedArray() : void
		 */
		private function deleteProcessedArray() : void {
			for ( var c : int = 0 ; c < fileProcessedArray.length ; c++ ) {
				var f : File = fileProcessedArray[c] as File;

				if ( f != null ) {
					f = null;
				}

				delete( fileProcessedArray[c] )
			}

			fileProcessedArray = new Array();
		}

		/**
		 * 
		 * 
		 * @method stopAllCurrentProcesses( ) : void
		 */
		private function stopAllCurrentProcesses() : void {
			if ( fileDataArray != null ) {
				for ( var d : int = 0 ; d < fileDataArray.length ; d++ ) {
					var da : ImageDataItem = fileDataArray.getItemAt(d) as ImageDataItem;
					da.destroy();
					da = null;
				}
			}

			deleteJPGEncoder();
			deleteBulkLoader();

			progress = 0;
			total = 0;

			setStatus(ImageImporter.IDLE);

			fileProcessedArray = new Array();
			fileDataArray = new ArrayCollection();
			jpgEncoderBusy = false;

			System.gc();

			// Trying to forge a GC run; - Not sure if this works in AIR
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch ( e : Error ) {
			}
		}

		/**
		 * 
		 * 
		 * @method deleteBulkLoader() : void
		 */
		private function deleteBulkLoader() : void {
			if ( rBulkLoader != null ) {
				rBulkLoader.pauseAll();
				rBulkLoader.removeAll();
				rBulkLoader.clear();
				rBulkLoader = null;

				System.gc();
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// INIT
		/**
		 * 
		 * 
		 * @method initJPGEncoder() : void
		 */
		private function initJPGEncoder() : void {
			deleteJPGEncoder();

			jpgGEncoder = new JPGEncoder(_quality);

			jpgGEncoder.addEventListener(ProgressEvent.PROGRESS, onEncodingProgress, false, 0, true);
			jpgGEncoder.addEventListener(Event.COMPLETE, onEncodingComplete, false, 0, true);
		}

		/**
		 * 
		 * 
		 * @method deleteJPGEncoder() : void
		 */
		private function deleteJPGEncoder() : void {
			if ( jpgGEncoder != null ) {
				jpgGEncoder.cleanUp(true) ;
				jpgGEncoder.removeEventListener(ProgressEvent.PROGRESS, onEncodingProgress);
				jpgGEncoder.removeEventListener(Event.COMPLETE, onEncodingComplete);
				jpgGEncoder = null;
			}
		}

		/**
		 * 
		 * 
		 * @method initLoader() : void
		 */
		private function initLoader() : void {
			deleteBulkLoader();

			rBulkLoader = new BulkLoader('ImageImporgerResizeLoader');
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ENCODING
		/**
		 * 
		 * 
		 * @method onEncodingProgress( e : ProgressEvent ) : void 
		 */
		private function onEncodingProgress(e : ProgressEvent) : void {
			var encodedImgData : ImageDataItem = fileDataArray.getItemAt(encodefileDataArrayIndex) as ImageDataItem;
			encodedImgData.encodeProgress = Math.round(( e.bytesLoaded / e.bytesTotal ) * 100);

			var de : ImageImporterEvent = new ImageImporterEvent(ImageImporterEvent.ENCODE_PROGRESS)
			de.total = total;
			de.progress = progress;
			de.imageData = encodedImgData;
			dispatchEvent(de);
		}

		/**
		 * 
		 * 
		 * @method onEncodingComplete( e : Event ) : void
		 */
		private function onEncodingComplete(e : Event) : void {
			var encodedImgData : ImageDataItem = fileDataArray.getItemAt(encodefileDataArrayIndex) as ImageDataItem;
			var fName : String = encodedImgData.getFileName();
			// 'image'+ (counter ++ ) + '.jpg'

			if ( fName.substr(fName.length - pngExtension.length, fName.length) == pngExtension )
				fName = fName.substr(0, fName.length - pngExtension.length) + jpgExtension;
			// Resized / Re-Encoded images are now JPG's - so change extension to match.

			var f : File = baseFolder.resolvePath(subFolderName + '/' + fName);

			// jpgGEncoder.ImageData.position = 0;

			fileIO.writeBinaryFile(f, jpgGEncoder.ImageData);
			// Write the file
			fileProcessedArray.push(f);
			// add reference to processed array

			// Memory / Garbage collection
			encodedImgData.destroyBitmapData();

			updateProgress(encodedImgData);

			FDelayCall.addCall(runNextEncode, this);
		}

		/**
		 * 
		 * 
		 * @method runNextEncode() : void 
		 */
		private function runNextEncode() : void {
			jpgGEncoder.cleanUp(true);
			jpgEncoderBusy = false;
			encodeNextFile()
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Bulk Loader
		/**
		 * 
		 * 
		 * @method ImageLoaded( e : Event ) : void
		 */
		private function ImageLoaded(e : Event) : void {
			if ( importerStoppedFlag ) return ;

			var item : LoadingItem = e.target as LoadingItem;
			item.removeEventListener(Event.COMPLETE, ImageLoaded);

			var uri : String = item.url.url
			var bm : Bitmap = rBulkLoader.getBitmap(uri);

			var img : ImageDataItem = getImageDataItemByProp('url', uri);
			img.ratio = calcResizeRatio(bm);
			img.bitmapData = MovieUtils.resizeBitmap(bm, calcResizeRatio(bm));

			bm.bitmapData.dispose();
			bm = null;

			encodeNextFile();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// File Utils
		/**
		 * 
		 * 
		 * @method CopyProgress( e : FileUtilsEvent ) : void
		 */
		private function CopyProgress(e : FileUtilsEvent) : void {
			var img : ImageDataItem = getImageDataItemByProp('filename', e.newFile.name)
			img.encodeProgress = 100;
			updateProgress(img);
			updateCopiedFileStatus(e.newFile);
		}

		/**
		 * 
		 * 
		 * @method CopyFilesComplete( e : FileUtilsEvent ) : void
		 */
		private function CopyFilesComplete(e : FileUtilsEvent) : void {
			if ( importerStoppedFlag ) return ;

			var img : ImageDataItem = getImageDataItemByProp('filename', e.newFile.name)
			img.encodeProgress = 100;
			updateProgress(img);
			updateCopiedFileStatus(e.newFile);

			loadImagesToBeResized();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET / SET -------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get progress() : int {
			return _progress;
		}

		public function set progress(progress : int) : void {
			_progress = progress;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get total() : int {
			return _total;
		}

		public function set total(total : int) : void {
			_total = total;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get status() : String {
			return _status;
		}

		public function set status(status : String) : void {
			_status = status;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get maxSize() : int {
			return _maxSize;
		}

		public function set maxSize(maxSize : int) : void {
			_maxSize = maxSize;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get subFolderName() : String {
			return _subFolderName;
		}

		public function set subFolderName(tempFolderName : String) : void {
			_subFolderName = tempFolderName;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get baseFolder() : File {
			return _baseFolder;
		}

		public function set baseFolder(baseFolder : File) : void {
			_baseFolder = baseFolder;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get quality() : int {
			return _quality;
		}

		public function set quality(quality : int) : void {
			_quality = quality;
		}
	}
}