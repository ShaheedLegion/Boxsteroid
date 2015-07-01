package inspirational.designs;
import openfl.display.Sprite;

/**
 * ...
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
		
		Sys.println("Transition - " + width + ":" + height);
		Sys.println("Passed args - " + sw + ":" + sh);
	}
	
	public function GetTransition():Transitions {
		return currentState;
	}
	
	public function SetTransition(state:Transitions) {
		currentState = state;
	}
}