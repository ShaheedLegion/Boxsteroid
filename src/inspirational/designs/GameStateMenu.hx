package inspirational.designs;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.events.Event;

class GameStateMenu extends GameState {
	private var bgBitmap:Bitmap;
	
	
	public function new(w:Int, h:Int, actionMan:ActionManager) {
		super(w, h, actionMan);
		super.addChild(this);
	}
	
	// Override some functions in GameState to perform level-specific logic.
	public override function Setup(graph:Graphics) {		
		Sys.println("Width and Height " + screenW + ":" + screenH);
		
		var bitmapData = Assets.getBitmapData("img/menu.png");
		bgBitmap = new Bitmap(bitmapData);
		addChild(bgBitmap);

		width = cast (screenW, Float);
		height = cast (screenH, Float);

		Sys.println("Bitmap - " + bgBitmap.visible + " info " + bgBitmap.x + "-" + bgBitmap.y + "-" + bgBitmap.width + "-" + bgBitmap.height);
		Sys.println("Menu info - " + width + ":" + height);
		
		// For debugging.
		graph.beginFill(0xffffff);
		graph.drawRect(0, 0, 15, 100);
		graph.endFill();
		
		Sys.println("Menu graphics - " + graphics);
	}
	
	public override function HandleEventAction(keyCode:Int) {
		var action:ActionManager.Actions = actionManager.getAction(keyCode);

		if (action == Back) {
			SetTransition(GoBack);
		}
		if (action == Confirm) {
			SetTransition(GoForward);
		}
	}
	
	public override function HandleReleaseAction(keyCode:Int) {
		// for now we don't care about key release action.
	}
	
	public override function Resize(event:Event) {
	}
	
	public override function Render(event:Event) {
	}
}