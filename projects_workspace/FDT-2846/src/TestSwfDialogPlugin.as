package {
	import fdt.resource.FdtResource;
	import fdt.resource.IFdtResource;

	import swf.bridge.FdtDialogBridge;
	import swf.bridge.FdtRequest;
	import swf.plugin.ISwfDialogPlugin;

	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	[SWF(width=0,height=0)]
	[FdtSwfPlugin(name="TestDialog", pluginType="dialog", preferredSize="300,200")]
	public class TestSwfDialogPlugin extends Sprite implements ISwfDialogPlugin {
		[Embed(source="../assets/stop.gif", mimeType="application/octet-stream")]
		private var _picture1 : Class;
		[Embed(source="../assets/debug_view.gif", mimeType="application/octet-stream")]
		private var _picture2 : Class;
		private var _fdtDialogBridge : FdtDialogBridge;
		private var button : PushButton;
		private var lastWidth : int;
		private var lastHeight : int;
		private var panel : Panel;
		private var label : Label;

		public function TestSwfDialogPlugin() {
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
			_fdtDialogBridge = new FdtDialogBridge(loaderInfo, this);
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

		public function init(startInfo : String) : void {
			var request : FdtRequest = new FdtRequest();
			request.add(_fdtDialogBridge.ui.registerImage("pic1", new _picture1()));
			request.add(_fdtDialogBridge.ui.registerImage("pic2", new _picture2()));
			request.add(_fdtDialogBridge.window.setImage("pic1"));
			request.add(_fdtDialogBridge.window.setName("Jepp"));
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
			_fdtDialogBridge.ui.registerImage("pic1", new _picture1()).sendTo(this, bo);
			_fdtDialogBridge.ui.registerImage("pic2", new _picture2()).sendTo(this, bo);
			// _fdtDialogBridge.view.setImage("pic1").sendTo(this, bo);
			// _fdtDialogBridge.view.setName("jepp").sendTo(this, bo);
		}

		private function bo(b : Boolean) : void {
			trace("Boolean: " + b);
		}

		public function setOptions(options : Dictionary) : void {
		}

		private function muh(e : Event) : void {
			_fdtDialogBridge.window.setName("Juppppu").sendTo(null, null);
			//			//  var d : DisplayObject = this; // _viewWindow.displayObject;
			//			//  var bmd : BitmapData = new BitmapData(d.width, d.height, false, 0);
			//			//  bmd.draw(d);
			//			//  var ba : ByteArray = new PNGEncoder().encode(bmd);
			// var dia : Panel = new Panel(null, 0, 0);
			// new PushButton(dia, 0, 0, "Open", muh);
			// new PushButton(dia, 0, 30, "Close", muh2);
			// addChild(dia);
			// var dow : FdtDisplayObjectWindow = new FdtDisplayObjectWindow(dia, "Jop", "pic2", 200, 200,true, this, dialogCloseRequest);
			// _fdtDialogBridge.ui.openDialog(dow).sendTo(null, null);
		}

		private function muh2(e : Event) : void {
			trace(label.text + " Open " + lastWidth + " " + lastHeight);
			// _swfViewPlugin.setViewImage("pic2");
			// _fdtDialogBridge.ui.closeDialog().sendTo(this, dialogClosed2);
		}

		public function dialogClosed2() : void {
			// , width : int, height : int) : void {
			// setSize(width, height);
			label.text = "Base";
		}

		public function dialogCloseRequest() : void {
			trace("Killer");
			// _fdtDialogBridge.ui.closeDialog().sendTo(this, dialogClosed2);
		}

		private function muh3(e : Event) : void {
			// _fdtViewBridge.workspace.container("contribution.com.powerflasher.fdt.ui.professional.swf.bridge", -1).sendTo(this, res);
			_fdtDialogBridge.workspace.projects().sendTo(this, res2);
			var ba : ByteArray = new ByteArray();
			ba.writeUTFBytes("Hallo leute");
			_fdtDialogBridge.workspace.createFile("/DebugTest_3_6/Hey.txt", ba, true).sendTo(this, res3);
			_fdtDialogBridge.workspace.createFolder("/DebugTest_3_6/Mill").sendTo(this, res3);
			_fdtDialogBridge.workspace.deleteResource("/DebugTest_3_6/Mill").sendTo(this, res4);
			_fdtDialogBridge.workspace.moveResource("/DebugTest_3_6/Hey.txt", "/DebugTest_3_6/Hey2.txt").sendTo(this, res5);
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

		// public function getScreenShot() : BitmapData {
		// var bmd : BitmapData = new BitmapData(lastWidth, lastHeight, true, 0);
		// bmd.draw(this);
		// return bmd;
		// }
		// public function setSize(x : uint, y : uint) : void {
		//			 //  graphics.drawCircle(x+10, y+10, 10);
		// graphics.endFill();
		// graphics.beginFill(0x0000FF);
		// var px : int = x / 2;
		// var py : int = y / 2;
		// lastWidth = x;
		// lastHeight = y;
		// this.x = -px;
		// this.y = -py;
		// panel.width = x;
		// panel.height = y;
		// trace(x + " " + y);
		//
		// graphics.beginFill(0x00FF00);
		// graphics.drawRect(0, 0, x, y);
		// graphics.endFill();
		// graphics.beginFill(0xFF00FF);
		// graphics.drawRect(5, 5, x-10, y-10);
		// graphics.endFill();
		//
		// if (x > 300) {
		// _swfViewPlugin.setImage("pic1");
		// } else {
		// _swfViewPlugin.setImage("pic2");
		// }
		// trace(stage.width+" "+stage.height);
		// }
		public function setSize(width : int, height : int) : void {
			panel.width = width;
			panel.height = height;
		}

		public function closeRequest() : void {
			_fdtDialogBridge.close("MyResult is cool");
		}

		public function onDialogueClosed(dialogInstanceId : String, result : String) : void {
		}
		public function onDialogClosed(dialogInstanceId : String, result : String) : void {
		}
	}
}
