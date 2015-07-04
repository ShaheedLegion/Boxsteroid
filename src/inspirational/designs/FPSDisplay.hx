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
	private var lastBoundary:Float;
	private var elapsedFrames:Int;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 20, inCol);
		text = "FPS: ";

		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
		lastBoundary = 0;
		elapsedFrames = 0;
	}
	
	private function onEnter(_)
	{	
		var now = Timer.stamp();
		if (now - lastBoundary > 1) {
			if (visible)
				text = "FPS: " + elapsedFrames;
			elapsedFrames = 0;
			lastBoundary = now;
			return;
		}
		
		++elapsedFrames;
	}
	
}
