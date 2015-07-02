package inspirational.designs;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * The playing game state. This class will deal with all game-specific logic.
 * @author Shaheed Abdol
 */

class GameStatePlay extends GameState
{
	private var bgBitmap:Bitmap;
	
	public function new(w:Int, h:Int, actionMan:ActionManager) 
	{
		super(w, h, actionMan);
		
		var bmpData:BitmapData = new BitmapData(w, h, 0xff3456ff);
		bgBitmap = new Bitmap(bmpData);
		addChild(bgBitmap);
		
		width = cast (screenW, Float);
		height = cast (screenH, Float);

	}
	
	public override function Setup(graph:Graphics) {

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
	
	public function onClickStart(event:MouseEvent) {
		SetTransition(GoForward);
	}
	
	public function onClickExit(event:MouseEvent) {
		SetTransition(Exit);
	}
}

// Add class here that extends sprite and has it's own bitmap data
// This class will form the basis of enemies and player sprites.