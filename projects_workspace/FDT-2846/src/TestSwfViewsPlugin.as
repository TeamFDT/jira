package {
	import fdt.resource.FdtResource;
	import fdt.resource.IFdtResource;

	import swf.bridge.AbstractFdtWindowBridge;
	import swf.bridge.FdtRequest;
	import swf.bridge.FdtViewBridge;
	import swf.plugin.ISwfViewPlugin;

	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	[SWF(width=0,height=0)]
	[FdtSwfPlugin(name="TestView", pluginType="views", toolTip="This is new an cool")]
	public class TestSwfViewsPlugin extends Sprite implements ISwfViewPlugin {
		[Embed(source="../assets/stop.gif", mimeType="application/octet-stream")]
		private var _picture1 : Class;
		[Embed(source="../assets/debug_view.gif", mimeType="application/octet-stream")]
		private var _picture2 : Class;
		private var _fdtViewBridge : AbstractFdtWindowBridge;
		private var button : PushButton;
		private var lastWidth : int;
		private var lastHeight : int;
		private var panel : Panel;
		private var label : Label;

		public function TestSwfViewsPlugin() {
			new FdtSwfPluginIcon();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			panel = new Panel(this, 0, 0);
			// stage.addChild(panel);
			button = new PushButton(panel, 0, 0, "Open", muh);
			// button = new PushButton(this, 0, 30, "Close", muh2);
			button = new PushButton(panel, 80, 30, "Kill", kill);
			// button = new PushButton(panel, 0, 60, "Request", muh3);
			label = new Label(panel, 0, 120, "Base");
			_fdtViewBridge = new FdtViewBridge(loaderInfo, this);
		}

		private function kill(e : Event) : void {
			var j : TestSwfViewsPlugin = null;
			try {
				trace("Hallo");
				j.init();
			} catch (e : Error) {
			}
			// j.init();
		}

		public function init() : void {
			var request : FdtRequest = new FdtRequest();
			request.add(_fdtViewBridge.ui.registerImage("pic1", new _picture1()));
			request.add(_fdtViewBridge.ui.registerImage("pic2", new _picture2()));
			request.add(_fdtViewBridge.window.setImage("pic1"));
			request.add(_fdtViewBridge.window.setName("Jepp"));
			// request.add(_fdtViewBridge.workspace.fileContent("/contribution.com.powerflasher.fdt.ui.professional.swf.bridge/src/Main.as"));
			request.sendTo(this, yeah);
		}

		private function yeah(a : Boolean, b : Boolean, c : Boolean, d : Boolean) : void {
			trace("yeah");
			trace(a);
			trace(b);
			trace(c);
			trace(d);
		}

		public function init2() : void {
			_fdtViewBridge.ui.registerImage("pic1", new _picture1()).sendTo(this, bo);
			_fdtViewBridge.ui.registerImage("pic2", new _picture2()).sendTo(this, bo);
			_fdtViewBridge.window.setImage("pic1").sendTo(this, bo);
			_fdtViewBridge.window.setName("jepp").sendTo(this, bo);
		}

		private function bo(b : Boolean) : void {
			trace("Boolean: " + b);
		}

		public function setOptions(options : Dictionary) : void {
		}

		private function muh(e : Event) : void {

			var dia : Panel = new Panel(null, 0, 0);
			new PushButton(dia, 0, 0, "Open", muh);
			new PushButton(dia, 0, 30, "Close", muh2);
			addChild(dia);
		}

		private function muh2(e : Event) : void {
			trace(label.text + " Open " + lastWidth + " " + lastHeight);

		}

		public function dialogClosed2() : void {
			label.text = "Base";
		}

		public function dialogCloseRequest() : void {
			trace("Killer");
		}

		private function muh3(e : Event) : void {
			_fdtViewBridge.workspace.projects().sendTo(this, res2);
			var ba : ByteArray = new ByteArray();
			ba.writeUTFBytes("Hallo leute");
			_fdtViewBridge.workspace.createFile("/DebugTest_3_6/Hey.txt", ba, true).sendTo(this, res3);
			_fdtViewBridge.workspace.createFolder("/DebugTest_3_6/Mill").sendTo(this, res3);
			_fdtViewBridge.workspace.deleteResource("/DebugTest_3_6/Mill").sendTo(this, res4);
			_fdtViewBridge.workspace.moveResource("/DebugTest_3_6/Hey.txt", "/DebugTest_3_6/Hey2.txt").sendTo(this, res5);
		}

		private function res5(f : FdtResource) : void {
			trace("Move: " + f.path);
		}

		private function res4(res : Boolean) : void {
			trace("Delete: " + res);
		}

		private function res2(vec : Vector.<IFdtResource>) : void {
			trace("Huh " + vec.length);
			for each (var r : FdtResource in vec) {
				trace(r.path);
			}
		}

		private function res3(f : FdtResource) : void {
			trace(f.path);
		}

		public function get viewDisplayObject() : DisplayObject {
			return panel;
		}

		public function setSize(width : int, height : int) : void {
			panel.setSize(width, height);
		}

		public function onDialogueClosed(dialogInstanceId : String, result : String) : void {
		}
		public function onDialogClosed(dialogInstanceId : String, result : String) : void {
		}
	}
}
