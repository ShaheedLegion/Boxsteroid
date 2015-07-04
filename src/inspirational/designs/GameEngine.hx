package src.inspirational.designs;

import inspirational.designs.StateManager;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
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
		Sys.println("New statemanager");
	}
	
	public function setup(event:Event, stageObj:DisplayObject) {
		stateManager.setup(event, stageObj);
		Sys.println("Setup statemanager");
	}

	public function resize(event:Event) {
		stateManager.resize(event);
		Sys.println("Resize statemanager");
	}
	
	public function render(event:Event) {
		stateManager.render(event);
	}
	
}