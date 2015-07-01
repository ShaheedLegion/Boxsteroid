package inspirational.designs;

import openfl.display.Sprite;

/**
 * Defines transitions between game states.
 * Base class for all game states.
 * @author Shaheed Abdol
 */

 enum Transitions {
	 Waiting;
	 Play;
	 Pause;
	 GoBack;
	 GoForward;
 }
 
class Transition extends Sprite
{
	private var currentState:Transitions;
	private var screenW:Int;
	private var screenH:Int;

	public function new(sw:Int, sh:Int) 
	{
		super();
		screenW = sw;
		screenH = sh;
		currentState = Play;
	}
	
	public function GetTransition():Transitions {
		return currentState;
	}
	
	public function SetTransition(state:Transitions) {
		currentState = state;
	}
}