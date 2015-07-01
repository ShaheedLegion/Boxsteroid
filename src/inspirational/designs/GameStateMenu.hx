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
		var bitmapData = Assets.getBitmapData("img/menu.png");
		bgBitmap = new Bitmap(bitmapData);
		addChild(bgBitmap);

		width = cast (screenW, Float);
		height = cast (screenH, Float);
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