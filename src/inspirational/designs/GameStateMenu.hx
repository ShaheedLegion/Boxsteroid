package inspirational.designs;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.events.Event;
import openfl.events.MouseEvent;

class GameStateMenu extends GameState {
	private var bgBitmap:Bitmap;
	
	public function new(w:Int, h:Int, actionMan:ActionManager) {
		super(w, h, actionMan);
		Sys.println("New gamestatemenu");
	}
	
	// Override some functions in GameState to perform level-specific logic.
	public override function Setup(graph:Graphics) {		
		var bitmapData = Assets.getBitmapData("img/menu.png");
		bgBitmap = new Bitmap(bitmapData);
		addChild(bgBitmap);

		width = cast (screenW, Float);
		height = cast (screenH, Float);
		
		var startBtn:Button = new Button();
		var exitBtn:Button = new Button();

		addChild(startBtn);
		addChild(exitBtn);
		startBtn.Setup(cast( (bgBitmap.width / 2) - 250, Int), cast((bgBitmap.height) - 100, Int), 100, 24, "Start Game");
		exitBtn.Setup(cast( (bgBitmap.width / 2), Int), cast((bgBitmap.height) - 100, Int), 100, 24, "Exit");

		startBtn.addEventListener( MouseEvent.CLICK, onClickStart );
		exitBtn.addEventListener( MouseEvent.CLICK, onClickExit );
		Sys.println("Setup gamestatemenu");
	}
	
	public override function HandleEventAction(keyCode:Int) {
		var action:ActionManager.Actions = actionManager.getAction(keyCode);

		if (action == Back) {
			Sys.println("Going back gamestatemenu");
			SetTransition(GoBack);
		}
		if (action == Confirm) {
			Sys.println("Going forward gamestatemenu");
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
	
	public function onClickStart(event:MouseEvent) {
		SetTransition(GoForward);
	}
	
	public function onClickExit(event:MouseEvent) {
		SetTransition(Exit);
	}
}