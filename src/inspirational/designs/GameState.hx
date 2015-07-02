package inspirational.designs;

import inspirational.designs.ActionManager.Actions;
import inspirational.designs.Transition.Transitions;
import openfl.display.Graphics;
import openfl.events.Event;

class GameState extends Transition implements TransitionQuery {
	private var actionManager:ActionManager;
	
	public function new (w:Int, h:Int, actionMan:ActionManager) {
		super(w, h);
		
		// Action Manager will translate platform-specific keycodes into game actions.
		actionManager = actionMan;
		
		// All transitions are set to waiting initially.
		// The actual transitions are coded into the derived classes.
		SetTransition(Waiting);
	}
	
	public function GetTransitionState():Transitions {
		return GetTransition();
	}
	
	public function GameStateRemoved() {
		SetTransition(Waiting);
	}
	
	// Functions that can be overridden in derived classes.
	public function Setup(graph:Graphics) {
	}
	
	public function HandleEventAction(keyCode:Int) {
	}
	
	public function HandleReleaseAction(keyCode:Int) {
	}
	
	public function Resize(event:Event) {
	}
	
	public function Render(event:Event) {
	}
}