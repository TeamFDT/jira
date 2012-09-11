
<!-- Begin

/*********************************************************************************************************************************************************************************
* 
*
*	Parse the queuery string
*
*********************************************************************************************************************************************************************************

**********************************************************************************************************************************************************************************/

function getURLArgs(caseBool){ 

  var casefree = ( (true == caseBool) || (caseBool >= 1)) ? true: false; 
  var args  = new Object(); 
  var query = parent.location.search.substring(1); 
  var pairs = query.split("&"); 
  
  for(var i = 0; i< pairs.length; i++){ 
  
		pairs[i]= unescape(pairs[i]); 
		var pos=pairs[i].indexOf('='); 
		if(-1 == pos) continue; 
		
		var argname; 
		
		if(true != casefree) { 
			argname = pairs[i].substring(0,pos); 
		} else { 
			argname = pairs[i].substring(0,pos).toLowerCase(); 
		} 
		
		var value = pairs[i].substring(pos+1); 
		args[argname] = value; 
		
	 } 
	 
  return args; 
  
} 
	
/*********************************************************************************************************************************************************************************
* 
*
*	URL variables from JS. KEY:
*
*********************************************************************************************************************************************************************************

	 		= 		

	
**********************************************************************************************************************************************************************************/

	
function initFlashVars( so ){
	
	// read the queuery string 
	var URLargs = getURLArgs(false);
	var str = "";
	var flag = false;
	// all flash vars have the _prm suffix added to them to identify them in flash
	
	for ( var c in URLargs ) { 
			so.addVariable(c + "_prm", URLargs[c]);
	}

}
   
		
//  End -->
