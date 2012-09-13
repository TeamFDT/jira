/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.app.Data
 * Version 	  	: 2
 * Description 	: Load an XML file and convert it to a data object ( if XML is compatible );
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti ( karim@kurst.co.uk )
 * Date 			: 08/01/08 - Created Class
 * 				: 18/02/09 - Added loadDataGroups functionality
 * 				: 24/03/09 - Added multi DP xml support
 *				: 18/01/10 - Fixed Bug with the dataobject data Class functionality
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 *
 *	static clean( )
 *	static getDataObject( group:String  = "default" ) : DataProvider
 *	static getItemAt( recordID:Number, group:String = "default" ) : Object
 *	static loadData( URI:String, group:String = "default" ) : Data
 *	static getInstance():Data
 *	static loadDataGroups( a:Array ) : Data
 *
 * EVENTS
 * 
 * 	import com.kurst.events.LoadEvent
 * 		LoadEvent.LOADED_DATA_GROUPS
 * 		LoadEvent.LOADED_DATA 
 * 
 *********************************************************************************************************************************************************************************
 * Usage			:
 *********************************************************************************************************************************************************************************
 * 	  
 * 	Load multiple XML data files:
 *
 *	var groupArray : Array = new Array();
 *		groupArray.push( {uri:'episodes.xml', group:'episodes' , multi:false})
 *		groupArray.push( {uri:'structure.xml', group:'structure' , multi:true})
 *		groupArray.push( {uri:'swearwords.xml', group:'swearwords' , multi:false})
 *
 *	var inst:Data = Data.loadDataGroups(groupArray)
 *		inst.addEventListener(LoadEvent.LOADED_DATA_GROUPS , AllGroupsLoaded, false, 0, true );
 *		inst.addEventListener(LoadEvent.LOADED_DATA , GroupLoaded, false, 0, true );
 *				 
 *********************************************************************************************************************************************************************************
 *	Timeline - load single Data files:
 *********************************************************************************************************************************************************************************
 *
 *	import com.kurst.app.Data
 *	Data.loadData( "books.xml" ).addEventListener( "onDataLoaded", onDataLoaded );
 *
 *	function onDataLoaded( eventObj:Object ):void {
 *		
 *		Data.getInstance( ).removeEventListener( "onDataLoaded", onDataLoaded );
 *		dg_mc.dataProvider = Data.getDataObject()
 *		play();
 *		
 *	}
 *
 *	btn.addEventListener( "click", clickHandler );
 *	function clickHandler( e:Object){Data.clean();}
 *
 *	stop();
 *
 **********************************************************************************************************************************************************************************
 * XML Structure
 **********************************************************************************************************************************************************************************
 *
 **********************************************************************************************************************************************************************************
 * MULTI Structure
 **********************************************************************************************************************************************************************************
 * 
 * 	<navigation>
 * 	
 *		<intro>  <!-- NAME OF DATA PROVIDER -->
 *		
 *			<navItem>
 *				<id 		type="number">1</id>
 *				<text 		type="string">VIDEO INTRODUCTION</text>
 *			</navItem>
 *			
 *			<navItem>
 *				<id 		type="number">2</id>
 *				<text 		type="string">MARCO PIERRE WHITE INTERVIEW</text>
 *			</navItem>
 *			
 *		</intro>
 *		
 *		<main>	<!-- NAME OF DATA PROVIDER -->
 *		
 *			<navItem>
 *				<id 		type="number">1</id>
 *				<text 		type="string">VIDEO INTRODUCTION</text>
 *			</navItem>
 *			
 *			<navItem>
 *				<id 		type="number">2</id>
 *				<text 		type="string">MARCO PIERRE WHITE INTERVIEW</text>
 *			</navItem>
 *			
 *		</main>
 *
 ***********************************************************************************************************************************************************************************
 * Default XML struture
 ***********************************************************************************************************************************************************************************
 *
 *	<books>
 *		
 *		<book isbna="2987231987211">
 *			<title>title 1</title>
 *			<author>author 1</author>
 *			<label>label 1</label>
 *			<isbn type="number">2987231987211</isbn>
 *		</book>
 *		
 *		<book isbna="2987231987211">
 *			<title>title 2</title>
 *			<author>author 2</author>
 *			<label>label 2</label>
 *			<isbn type="number">2987231987211</isbn>
 *		</book>
 *	
 *	 </books>
 *	 
 **********************************************************************************************************************************************************************************/
package com.kurst.app {
	import com.kurst.data.XmlToCollection;
	import com.kurst.events.LoadEvent;
	import com.kurst.events.eventDispatcher;
	import com.kurst.utils.FDelayCall;

	import mx.collections.ArrayCollection;

	public class Data extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static var __appData : Data;

		// -STATIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// SSSSS TTTTTT   AAA   TTTTTT IIIIII  CCCCC
		// SS       TT    AAAAA    TT     II   CC   CC
		// SSSS    TT   AA   AA   TT     II   CC
		// SS   TT   AAAAAAA   TT     II   CC   CC
		// SSSSS    TT   AA   AA   TT   IIIIII  CCCCC
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * clean( )
		 * 
		 * clean the XML loader
		 * 
		 * @usage   Data.clean()
		 */
		public static function clean() : void {
			getInstance()._clean();
		}
		/**
		 * getDataObject
		 * 
		 * return a data object
		 * 
		 * @usage   var da:ArrayCollection = Data.getDataObject( 'nameOfGroup' );
		 * @param   group 
		 * @return  ArrayCollection
		 */
		public static function getDataObject(group : String = "default") : ArrayCollection {
			return getInstance()._getDataObject(group);
		}
		/**
		 * enumerateGroups
		 * 
		 * enumerate all groups in the Data store
		 * 
		 * @usage 	var a:Array = Data.enumerateGroups()'
		 * @return 	Array of group names  
		 */
		public static function enumerateGroups() : Array {
			return getInstance()._enumerateGroups();
		}

		/**
		 * getItemAt
		 * 
		 * @usage 	Data.getItemAt( 10 , 'nameOfGroup' );
		 * @param   recordID : Number
		 * @param	
		 * @return  
		 */
		public static function getItemAt(recordID : Number, group : String = "default") : Object {
			return getInstance()._getItemAt(recordID, group);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param 
		 * @param
		 * @param 
		 */
		public static function getItemByKey(name : String, key : String, group : String = "default") : Object {
			return getInstance()._getItemByKey(name, key, group);
		}

		/**
		 * loadData
		 * 
		 * load an xml file, and convert it to a data provider
		 * Structure of XML:
		 *
		 *	<books>
		 *		
		 *		<book isbna="2987231987211">
		 *			<title>title 1</title>
		 *			<author>author 1</author>
		 *			<label>label 1</label>
		 *			<isbn type="number">2987231987211</isbn>
		 *		</book>
		 *		
		 *		<book isbna="2987231987211">
		 *			<title>title 2</title>
		 *			<author>author 2</author>
		 *			<label>label 2</label>
		 *			<isbn type="number">2987231987211</isbn>
		 *		</book>
		 *	
		 *	 </books>
		 * 
		 * @usage   Data.loadData( 'data.xml' , 'nameOfGroup' ).addEventListener( LoadEvent.DATA_LOADED, myListener ); 
		 * @param   URI 	location of XML file
		 * @param	group 	name / id of group to load
		 * 
		 * @return  Reference to Data singleton
		 */
		public static function loadData(URI : String, group : String = "default", multiXmlFlag : Boolean = false, dataobject : Class = null) : Data {
			var inst : Data = getInstance();
			inst._loadData(URI, group, multiXmlFlag, dataobject);

			return inst;
		}

		/**
		 * loadMultiPartData
		 * 
		 * Load an xml file that contains groups of Data Providers. 
		 * Structure of XML :
		 * 	<navigation>
		 * 	
		 *		<intro>  <!-- NAME OF DATA PROVIDER -->
		 *		
		 *			<navItem>
		 *				<id 		type="number">1</id>
		 *				<text 		type="string">VIDEO INTRODUCTION</text>
		 *			</navItem>
		 *			
		 *			<navItem>
		 *				<id 		type="number">2</id>
		 *				<text 		type="string">MARCO PIERRE WHITE INTERVIEW</text>
		 *			</navItem>
		 *			
		 *		</intro>
		 *		
		 *		<main>	<!-- NAME OF DATA PROVIDER -->
		 *		
		 *			<navItem>
		 *				<id 		type="number">1</id>
		 *				<text 		type="string">VIDEO INTRODUCTION</text>
		 *			</navItem>
		 *			
		 *			<navItem>
		 *				<id 		type="number">2</id>
		 *				<text 		type="string">MARCO PIERRE WHITE INTERVIEW</text>
		 *			</navItem>
		 *			
		 *		</main>
		 *
		 * </navigation>
		 * 
		 * @usage  	Data.loadMultiPartData( 'datagroups.xml' ).addEventListener( LoadEvent.DATA_LOADED, myListener ); 
		 * @param   URI 
		 * @return  Reference to Data singleton
		 */
		public static function loadMultiPartData(URI : String, dataobject : Class = null) : Data {
			var inst : Data = getInstance();
			inst._loadData(URI, 'default', true, dataobject);

			return inst;
		}

		/**
		 * loadDataGroups
		 * 
		 * @usage load groups of xml files 
		 * @param a:Array of XML files and group names to load:
		 * 
		 * @usage
		 * 
		 *		var groupArray : Array = new Array();
		 *			groupArray.push( {uri:'episodes.xml', group:'episodes', multi:true})
		 *			groupArray.push( {uri:'structure.xml', group:'structure', multi:false , dataobject:com.wc2010.data.item.SectionContentItem})
		 *			groupArray.push( {uri:'swearwords.xml', group:'swearwords'}) 
		 * @notes
		 * 
		 * 		uri 		: String 	- URL of XML file
		 * 		group 		: String 	- Name / Id of group
		 * 		multi		: Boolean 	- ( optional ) load a multipat xml file 
		 * 		dataobject	: String	- ( optional ) use a class container for data 
		 * 
		 * @return  Data
		 */
		public static function loadDataGroups(a : Array) : Data {
			var inst : Data = getInstance();
			inst._loadDataGroups(a);

			return inst;
		}

		/**
		 * getInstance()
		 * 
		 * get a reference to the Singleton instance
		 * 
		 * @usage   Data.getInstance().addEventListener( LoadEvent.DATA_LOADED, myListener );
		 * @return  Data class
		 */
		public static function getInstance() : Data {
			if ( __appData == null ) {
				__appData = new Data();
			}

			return __appData;
		}

		// -CONSTRUCTOR-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// CCCCC   OOOO  NN  NN  SSSSS TTTTTT RRRRR   UU   UU  CCCCC  TTTTTT  OOOO  RRRRR
		// CC   CC OO  OO NNN NN SS       TT   RR  RR  UU   UU CC   CC   TT   OO  OO RR  RR
		// CC      OO  OO NNNNNN  SSSS    TT   RRRRR   UU   UU CC        TT   OO  OO RRRRR
		// CC   CC OO  OO NN NNN     SS   TT   RR  RR  UU   UU CC   CC   TT   OO  OO RR  RR
		// CCCCC   OOOO  NN  NN SSSSS    TT   RR   RR  UUUUU   CCCCC    TT    OOOO  RR   RR
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var xml_do : XmlToCollection;
		private var records : Object;
		private var currentGroup : String;
		private var dataGroups : Array;
		private var dataGroupPointer : Number;
		private var loadGroupArrayFlag : Boolean = false;
		private var _multiXmlFlag : Boolean = false;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function Data() {
			records = new Object();
		}

		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  UU   UU BBBBBB  LL      IIIIII  CCCCC
		// PP   PP UU   UU BB   BB LL        II   CC   CC
		// PPPPPP  UU   UU BBBBBB  LL        II   CC
		// PP      UU   UU BB   BB LL        II   CC   CC
		// PP       UUUUU  BBBBBB  LLLLLLL IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * _loadDataGroups
		 * 
		 * @usage load groups of xml files 
		 * @param a:Array of XML files and group names to load:
		 * 
		 * @usage
		 * 
		 *		var groupArray : Array = new Array();
		 *			groupArray.push( {uri:'episodes.xml', group:'episodes', multi:true})
		 *			groupArray.push( {uri:'structure.xml', group:'structure', multi:false})
		 *			groupArray.push( {uri:'swearwords.xml', group:'swearwords'}) 
		 * @notes
		 * 
		 * 		uri 	: String 	- URL of XML file
		 * 		group 	: String 	- Name / Id of group
		 * 		multi	: Boolean 	- ( optional ) load a multipat xml file 
		 * 
		 * @return  Data
		 */
		public function _loadDataGroups(a : Array) : void {
			// _startLoadDataGroups - Delay Call - to enable GC / Refresh the object
			// dc.call('_startLoadDataGroups', this, a );
			FDelayCall.addCall(_startLoadDataGroups, this, a);
		}
		/**
		 * @method _startLoadDataGroups
		 * @tooltip start loading the data groups
		 * @param a : Array - see _loadDataGroups
		 */
		public function _startLoadDataGroups(a : Array) : void {
			dataGroupPointer = 0;
			dataGroups = a;
			loadGroupArrayFlag = true;

			var isMultiXml : Boolean = ( dataGroups[dataGroupPointer].multi == null ) ? false : dataGroups[dataGroupPointer].multi;

			_loadData(dataGroups[dataGroupPointer].uri, dataGroups[dataGroupPointer].group, isMultiXml, dataGroups[dataGroupPointer].dataobject);
		}
		/**
		 * @method _clean
		 */
		public function _clean() : void {
			xml_do.removeEventListener(LoadEvent.LOADED_DATA, onDataLoaded);
			xml_do = null;
		}
		/**
		 * @method  _getDataObject( group:String  = "default" ):ArrayCollection
		 * @tooltip get a dataobject 
		 * @param group : String - name of ArrayCollection 
		 * @return ArrayCollection
		 */
		public function _getDataObject(group : String = "default") : ArrayCollection {
			var DP : ArrayCollection = records[group] as ArrayCollection;

			return DP;
		}
		/**
		 * @method _getItemAt( recordID:Number, group:String  = "default" ):Object
		 * @tooltip get a record from a ArrayCollection
		 * @param  	recordID:Number				- Position of record with a ArrayCollection
		 * @param	group:String  = "default"	- name of ArrayCollection 
		 * @return 	Object
		 */
		public function _getItemAt(recordID : Number, group : String = "default") : Object {
			var dp : ArrayCollection = records[group] as ArrayCollection;
			var rec : Object = dp.getItemAt(recordID);

			return rec
		}
		/**
		 * @method 
		 * @tooltip 
		 * @param  	
		 * @param	 
		 * @return 	
		 */
		public function _getItemByKey(name : String, key : String, group : String = "default") : Object {
			if ( records[group] == null ) return {};

			var dp : ArrayCollection = records[group] as ArrayCollection;
			// var l : int 			= dp.length;

			for ( var c : int = 0 ; c < dp.length ; c++ ) {
				var rec : Object = dp.getItemAt(c);

				if ( rec[name] == key )
					return rec;
			}

			return null;
		}
		/**
		 * loadData
		 * 
		 * load an xml file, and convert it to a data provider
		 * Structure of XML:
		 *
		 *	<books>
		 *		
		 *		<book isbna="2987231987211">
		 *			<title>title 1</title>
		 *			<author>author 1</author>
		 *			<label>label 1</label>
		 *			<isbn type="number">2987231987211</isbn>
		 *		</book>
		 *		
		 *		<book isbna="2987231987211">
		 *			<title>title 2</title>
		 *			<author>author 2</author>
		 *			<label>label 2</label>
		 *			<isbn type="number">2987231987211</isbn>
		 *		</book>
		 *	
		 *	 </books>
		 * 
		 * @usage   Data.loadData( 'data.xml' , 'nameOfGroup' ).addEventListener( LoadEvent.DATA_LOADED, myListener ); 
		 * @param   URI 	location of XML file
		 * @param	group 	name / id of group to load
		 * 
		 * @return  Reference to Data singleton
		 */
		public function _loadData(URI : String, group : String = "default", multiXmlFlag : Boolean = false, dataobject : Class = null) : void {
			_multiXmlFlag = multiXmlFlag;
			currentGroup = group;

			// trace('data._loadData: ' + ClassUtils.getClassName( dataobject ) + ' dataObject : ' + dataobject );

			if ( xml_do != null )
				xml_do.removeEventListener(LoadEvent.LOADED_DATA, onDataLoaded);

			xml_do = new XmlToCollection();

			if ( dataobject != null )
				xml_do.customDataClass = dataobject;

			xml_do.addEventListener(LoadEvent.LOADED_DATA, onDataLoaded);
			xml_do.load(URI, multiXmlFlag);
		}
		/**
		 * enumerateGroups
		 * 
		 * enumerate all groups in the Data store
		 * 
		 * @usage 	var a:Array = Data.enumerateGroups()'
		 * @return 	Array of group names  
		 */
		public function _enumerateGroups() : Array {
			var returnset : Array = new Array();

			for ( var i : String in records ) {
				returnset.push(i);
			}

			return returnset;
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
		
		/**
		 * onDataLoaded
		 * @tooltip	Event Handler for XmlToDataObject - Data Loaded and Parsed
		 */
		private function onDataLoaded(event : LoadEvent) : void {
			if ( _multiXmlFlag ) {
				// -----------------------------------------------------
				// MULTIPLART XML
				// -----------------------------------------------------

				var recordGroup : Object = xml_do.dataProviders;

				// Add every ArrayCollection in xml_do.dataProviderGroup to the Data store
				for ( var i:String in recordGroup )
					records[i] = ArrayCollection(recordGroup[i]);
			} else {
				// -----------------------------------------------------
				// SIMPLE XML
				// -----------------------------------------------------

				records[currentGroup] = xml_do.data;
			}

			// REMOVE XmlToDataObject event listener
			xml_do.removeEventListener(LoadEvent.LOADED_DATA, onDataLoaded);

			// Dispatch loaded event
			var ev : LoadEvent = new LoadEvent(LoadEvent.LOADED_DATA);
			ev.group = currentGroup;
			dispatchEvent(ev);

			// reset the multi part xml flag
			_multiXmlFlag = false;

			// Group / Multi XML load logic
			if ( loadGroupArrayFlag ) {
				// increment the load pointer
				dataGroupPointer++;

				// check if we are at the end of the load array
				if ( dataGroupPointer < dataGroups.length  ) {
					// load the next xml file
					var isMultiXml : Boolean = ( dataGroups[dataGroupPointer].multi == null ) ? false : dataGroups[dataGroupPointer].multi;

					// _loadData - Delay Call - to enable GC / Refresh the object

					FDelayCall.addCall(_loadData, this, dataGroups[dataGroupPointer].uri, dataGroups[dataGroupPointer].group, isMultiXml, dataGroups[dataGroupPointer].dataobject);
				} else {
					var de : LoadEvent = new LoadEvent(LoadEvent.LOADED_DATA_GROUPS);
					// finished loading all xml files.
					dispatchEvent(de);
					loadGroupArrayFlag = false;
					dataGroupPointer = 0;
				}
			}
		}
	}
}
