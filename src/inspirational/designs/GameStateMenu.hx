package inspirational.designs;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.events.Event;
import openfl.events.MouseEvent;

class GameStateMenu extends GameState {
	private var bgBitmap:Bitmap;
	private var gameStarted:Bool;
	
	public function new(w:Int, h:Int, actionMan:ActionManager) {
		super(w, h, actionMan);
		//super.addChild(this);
		gameStarted = false;
	}
	
	// Override some functions in GameState to perform level-specific logic.
	public override function Setup(graph:Graphics) {		
		var bitmapData = Assets.getBitmapData("img/menu.png");
		bgBitmap = new Bitmap(bitmapData);
		addChild(bgBitmap);

		width = cast (screenW, Float);
		height = cast (screenH, Float);
		

		Sys.println("Adding button");
		var button:Button = new Button(100, 100);
		Sys.println("Added button");
		addChild(button);
		button.Setup(100, 24, "Start Game");
		Sys.println("Added button event listener");
		button.addEventListener( MouseEvent.CLICK, onClick );
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
	
	public function onClick(event:MouseEvent) {
		gameStarted = true;
		SetTransition(GoForward);
	}
}