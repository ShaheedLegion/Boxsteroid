package src.inspirational.designs;

import inspirational.designs.StateManager;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Shaheed Abdol
 */

class GameEngine extends Sprite
{
	private var stateManager:GameStateManager;

	public function new(w:Int, h:Int) 
	{
		super();

		stateManager = new GameStateManager(w, h);
		this.addChild(stateManager);
	}
	
	public function setup(event:Event, stageObj:DisplayObject) {
		stateManager.setup(event, stageObj);
	}

	public function resize(event:Event) {
		stateManager.resize(event);
	}
	
	public function render(event:Event) {
		stateManager.render(event);
	}
	
}