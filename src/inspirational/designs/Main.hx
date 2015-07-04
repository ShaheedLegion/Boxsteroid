package inspirational.designs;

import src.inspirational.designs.GameEngine;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.Lib;

/**
 * Main entry point of game.
 * @author Shaheed Abdol
 */
class Main extends Sprite 
{
	private var engine:GameEngine;	
	private static var screenW:Int;
	private static var screenH:Int;
	private var fpsDisplay:FPSDisplay;
	
	public function new() 
	{
		super();
		
		engine = new GameEngine(screenW, screenH);
		this.addChild(engine);
		
		//fpsDisplay = new FPSDisplay(10, 10, 0xffffff);
		//this.addChild(fpsDisplay);

		Sys.println("New main");
		addEventListener(Event.ADDED_TO_STAGE, setup);
	}

	function setup(event:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, setup);		
		stage.addEventListener(Event.RESIZE, resize);
		this.addEventListener(Event.ENTER_FRAME, render);
		Sys.println("Setup main");
		engine.setup(event, stage);
	}

	function resize(event:Event) {
		engine.resize(event);
		Sys.println("Resize main");
	}
	
	private function render(event:Event):Void {
		engine.render(event);
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN;
		screenW = Lib.current.stage.stageWidth;
		screenH = Lib.current.stage.stageHeight;
		Lib.current.addChild(new Main());
	}
}
