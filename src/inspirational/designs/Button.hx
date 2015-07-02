package inspirational.designs;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;
/**
 * ...
 * @author Shaheed Abdol
 */

 class Button extends Sprite {
	 
	public function new()
    {
        super();
    }
	 
	
	public function Setup(tx:Int, ty:Int, w:Int, h:Int, label:String) {
		this.addChild(new ButtonText(w, h, label));
		
		x = tx;
		y = ty;
		width = w;
		height = h;
		
        drawBasicRect(false);
		addEventListener(MouseEvent.MOUSE_OVER, drawBasicRectOver);
		addEventListener(MouseEvent.MOUSE_OUT, drawBasicRectNormal);
	}
	
	function drawBasicRect(highlight:Bool)
    {
        this.graphics.beginFill( highlight ? 0xFFFFFF : 0xbb0000 );
        this.graphics.drawRoundRect( 0, 0, width, height, 10, 10 );
        this.graphics.endFill();
    }
	
	function drawBasicRectOver(event:MouseEvent) {
		drawBasicRect(true);
	}
    function drawBasicRectNormal(event:MouseEvent) {
		drawBasicRect(false);
	}	
 }
 
 
class ButtonText extends TextField
{
	public function new(w:Int, h:Int, label:String) 
	{
		super();
		
		selectable = false;
		var messageFormat:TextFormat = new TextFormat("_sans", 18, 0x000000);
		messageFormat.align = TextFormatAlign.CENTER;

		text = label;
		width = w;
		height = h;
		
		defaultTextFormat = messageFormat;
	}
}
