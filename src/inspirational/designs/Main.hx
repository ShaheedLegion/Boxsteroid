package inspirational.designs;

import src.inspirational.designs.GameEngine;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Shaheed Abdol
 */
class Main extends Sprite 
{
	private var engine:GameEngine;	
	private static var screenW:Int;
	private static var screenH:Int;
	
	public function new() 
	{
		super();
		
		engine = new GameEngine(screenW, screenH);
		this.addChild(engine);
		addEventListener(Event.ADDED_TO_STAGE, setup);
	}

	function setup(event:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, setup);		
		stage.addEventListener(Event.RESIZE, resize);
		this.addEventListener(Event.ENTER_FRAME, render);
		
		engine.setup(event, stage);
	}

	function resize(event:Event) {
		engine.resize(event);
	}
	
	private function render(event:Event):Void {
		engine.render(event);
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		screenW = Lib.current.stage.stageWidth;
		screenH = Lib.current.stage.stageHeight;
		Lib.current.addChild(new Main());
	}
}
