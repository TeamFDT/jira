package com.kurst.visuals.core {
	import com.kurst.visuals.data.AssetVo;

	public interface IComp {
		function destroy() : void;

		function startVisuals() : void;

		function stopVisuals() : void ;

		function setAssets(assets : Vector.<AssetVo> = null) : void;
	}
}
