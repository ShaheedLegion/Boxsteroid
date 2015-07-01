package inspirational.designs;

/**
 * Translates platform key events into game actions.
 * @author Shaheed Abdol
 */
enum Actions {
	Left;
	Right;
	Up;
	Down;
	Confirm;
	Back;
}
 
class ActionManager
{

	public function new() 
	{
		
	}
	
	public function getAction(key:Int):Actions {
		return Back;
	}
	
}