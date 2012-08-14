package com.realaxy.modules.decorator.windows {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;

	import com.realaxy.app_layout.events.LayoutEvent;
	import com.realaxy.app_layout.models.ILayoutContent;
	import com.realaxy.app_layout.models.LayoutCellModel;
	import com.realaxy.modules.decorator.view3d.objects.environments.Environment3D;
	import com.realaxy.modules.utils.stage3d.uploadResources;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.events.Event;

	public class DecoratorWindow extends Sprite implements ILayoutContent {
		private var rootContainer : Object3D;
		private var camera : Camera3D;
		[Inject]
		public var stage3D : Stage3D;
		[Inject]
		public var eventSource : Stage;
		private var simpleObjectController : SimpleObjectController;

		public function DecoratorWindow() {
		}

		[PostConstruct]
		public function initInstance() : void {
			rootContainer = new Object3D();

			camera = new Camera3D(1, 10000);
			camera.view = new View(100, 100, false, 0x000000, 1, 16);
			camera.view.hideLogo();
			camera.diagramAlign = StageAlign.BOTTOM_RIGHT;
			addChild(camera.view);
			addChild(camera.diagram);
			rootContainer.addChild(camera);
			camera.x = -252.8063201904297;
			camera.y = 160.1342010498047;
			camera.z = 154.85861206054688;
			camera.rotationX = -1.483529806137085;
			camera.rotationY = 0;
			camera.rotationZ = 0.12217296659946442;
			rootContainer.addChild(new Environment3D());

					simpleObjectControll r = new SimpleObjectController(eventSourc , camer , 5000

					uploadResources(rootContainer
					addEventListener(Event.ENTER_FRAM , onEnterFrame
			

				private function onEnterFrame(eve t : Even ) : vo d
					simpleObjectController.update(
					camera.render(stage3D
			

				 / ------------------------------------------------------------------------
				
				 / LAYOUT METHO
				
				 / ------------------------------------------------------------------------
				private var _cellMod l : LayoutCellMode

				public function setLayoutCell(cellMod l : LayoutCellMode ) : vo d
					_cellMod l = cellMode
					_cellModel.addEventListener(LayoutEvent.LAYOUT_RESIZ , onLayoutResize
					onLayoutResize(null
			

				private function onLayoutResize(eve t : LayoutEven ) : vo d
				 x = _cellModel.
				 y = _cellModel.
					camera.view.wid h = _cellModel.widt
					camera.view.heig t = _cellModel.heigh
			

				public function get minWidth ) : Numb r
					return 20
			

				public function get minHeight ) : Numb r
					return 20
			

				public function get maxWidth ) : Numb r
					return 200
			

				public function get maxHeight ) : Numb r
					return 200
			
	


}
