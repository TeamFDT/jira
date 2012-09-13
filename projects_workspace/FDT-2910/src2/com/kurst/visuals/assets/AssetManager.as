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
package com.kurst.visuals.assets {
	import com.kurst.app.Data;
	import com.kurst.events.LoadEvent;
	import com.kurst.events.eventDispatcher;
	import com.kurst.visuals.data.AssetVo;
	import com.kurst.visuals.data.DaeVO;

	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;

	import flash.events.Event;

	public class AssetManager extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var daeAssetLib : Vector.<DaeVO>;
		private var deaLoadItem : DaeVO;
		private var dataGroupArray : Array;
		private var daeLoadCounter : int

		public function AssetManager() {
			daeAssetLib = new Vector.<DaeVO>();
			dataGroupArray = new Array();
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
		public function startLoad() : void {
			daeLoadCounter = 0;
			loadNextDae();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function addXML(id : String, uri : String, multi : Boolean = false) : void {
			var dataObject : Object = new Object();
			dataObject.uri = uri
			dataObject.group = id;
			dataObject.multi = multi
			dataGroupArray.push(dataObject)

			/*
			 * Notes
			 *		
			 *		groupArray.push( {uri:'episodes.xml', group:'episodes', multi:true})
			 *		groupArray.push( {uri:'structure.xml', group:'structure', multi:false , dataobject:com.wc2010.data.item.SectionContentItem})
			 *		groupArray.push( {uri:'swearwords.xml', group:'swearwords'})
			 *		 
			 */
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function addDae(id : String, uri : String, initScale : Number = 1) : void {
			var vo : DaeVO = new DaeVO();
			vo.id = id;
			vo.uri = uri;
			vo.initScale = initScale;
			daeAssetLib.push(vo);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function addDaeString(id : String, data : String, initScale : Number = 1, group : String = 'default') : void {
			var xml : XML = new XML(data)

			var daeVO : DaeVO = new DaeVO();

			daeVO.id = id
			daeVO.initScale = initScale;
			daeVO.loaded = false;
			daeVO.xml = xml
			daeVO.group = group;

			daeAssetLib.push(daeVO);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function loadData() : void {
			if ( dataGroupArray.length == 0 ) {
				allDataLoaded();
			} else {
				Data.loadDataGroups(dataGroupArray);
				Data.getInstance().addEventListener(LoadEvent.LOADED_DATA_GROUPS, dataLoaded, false, 0, true);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function loadNextDae() : Boolean {
			var vo : DaeVO

			for ( var c : int = 0 ; c < daeAssetLib.length ;c++  ) {
				vo = daeAssetLib[c];

				if ( !vo.loaded ) {
					deaLoadItem = vo;

					vo.dae = new DAE(false, vo.id, false);

					if ( vo.xml != null ) {
						vo.dae.load(vo.xml);
					} else {
						vo.dae.load(vo.uri);
					}

					vo.dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, daeLoadComplete, false, 0, true);

					var e : LoadEvent = new LoadEvent(LoadEvent.PROGRESS)
					e.itemsTotal = daeAssetLib.length;
					e.itemsLoaded = ( daeLoadCounter++ ) + 1 ;
					dispatchEvent(e);

					return true;
				}
			}

			return false;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function getGeom(obj : DisplayObject3D) : DisplayObject3D {
			if ( obj == null ) return obj;
			if ( obj.geometry != null ) return obj;

			var do3D : DisplayObject3D = getColladaDisplayObj(obj);

			if ( do3D == null ) return obj;

			if ( do3D.geometry != null )
				return do3D;

			return getGeom(do3D);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function getColladaDisplayObj(tempCO : DisplayObject3D) : DisplayObject3D {
			var returnObj : DisplayObject3D;

			try {
				var childname : String = String(tempCO.childrenList()).substring(0, String(tempCO.childrenList()).indexOf(": "));
				returnObj = tempCO.getChildByName(childname);
			} catch(errObject : Error) {
				trace(errObject.message);
			}

			return returnObj;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function getDaeObjectByName(id : String) : DaeVO {
			var daeVO : DaeVO

			for ( var c : int = 0 ; c < daeAssetLib.length ; c++ ) {
				daeVO = daeAssetLib[c]

				if ( daeVO.id == id ) {
					return daeVO;
				}
			}

			return daeVO;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function allDataLoaded() : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getAssets() : Vector.<AssetVo> {
			var result : Vector.<AssetVo> = new Vector.<AssetVo>();
			var assetVo : AssetVo;
			var daeVO : DaeVO

			// Get DAE Object
			for ( var c : int = 0 ; c < daeAssetLib.length ; c++ ) {
				daeVO = daeAssetLib[c]

				assetVo = new AssetVo();
				assetVo.id = daeVO.id;
				assetVo.do3d = daeVO.daeGeometry
				assetVo.dae = daeVO.dae
				assetVo.group = daeVO.group;

				result.push(assetVo);
			}

			return result;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getAssetByName(id : String) : AssetVo {
			var assetVo : AssetVo;
			var daeVO : DaeVO

			for ( var c : int = 0 ; c < daeAssetLib.length ; c++ ) {
				daeVO = daeAssetLib[c]

				if ( daeVO.id == id ) {
					assetVo = new AssetVo();
					assetVo.id = daeVO.id;
					assetVo.do3d = daeVO.daeGeometry
					assetVo.dae = daeVO.dae
				}
			}

			return assetVo;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function dataLoaded(event : LoadEvent) : void {
			allDataLoaded();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function daeLoadComplete(event : FileLoadEvent) : void {
			deaLoadItem.dae.removeEventListener(FileLoadEvent.LOAD_COMPLETE, daeLoadComplete);
			deaLoadItem.dae.useOwnContainer = true;
			deaLoadItem.daeGeometry = getGeom(deaLoadItem.dae);

			deaLoadItem.daeGeometry.scaleX = deaLoadItem.daeGeometry.scaleY = deaLoadItem.daeGeometry.scaleZ = deaLoadItem.initScale;
			deaLoadItem.loaded = true;

			if ( !loadNextDae() ) {
				loadData();
			}
		}
	}
}
