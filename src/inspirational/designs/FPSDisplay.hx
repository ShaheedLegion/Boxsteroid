package inspirational.designs;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Shaheed Abdol
 */
class FPSDisplay extends TextField
{
	private var times:Array<Float>;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 20, inCol);
		
		text = "FPS: ";
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
	}
	
	private function onEnter(_)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
		
		if (visible)
		{	
			text = "FPS: " + times.length;	
		}
	}
	
}
