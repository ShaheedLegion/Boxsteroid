package inspirational.designs;

import inspirational.designs.BSPTree;
import inspirational.designs.BSPTree.TreeVisualizer;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * The playing game state. This class will deal with all game-specific logic.
 * @author Shaheed Abdol
 */

class GameStatePlay extends GameState
{
	private var bspTree:BSPTree;
	private var bgBitmap:Bitmap;
	private var enemies:Array<EnemyBlock>;
	
	private var treeViz:TreeVisualizer;
	private var screenRect:Rectangle;
	
	public function new(w:Int, h:Int, actionMan:ActionManager) 
	{
		super(w, h, actionMan);
		
		// Represents the entire playable area.
		screenRect = new Rectangle(0, 0, w, h);
		screenRect.inflate(100, 100);
		
		var bmpData:BitmapData = new BitmapData(Std.int(screenRect.width), Std.int(screenRect.height), 0xff3456ff);
		bgBitmap = new Bitmap(bmpData);
		addChild(bgBitmap);
		
		width = cast (screenRect.width, Float);
		height = cast (screenRect.height, Float);
		
		bspTree = new BSPTree(screenRect);
		enemies = new Array<EnemyBlock>();
		
		for (i in 0...300) {
			var enemy:EnemyBlock = new EnemyBlock();
			addChild(enemy);
			enemies.push(enemy);
		}
	}
	
	public override function Setup(graph:Graphics) {
		for (enemy in enemies) {
			enemy.Setup(bspTree, bgBitmap.width, bgBitmap.height, 100);
		}
		
		treeViz = new TreeVisualizer(bspTree);
		addChild(treeViz);
	}
	
	public override function HandleEventAction(keyCode:Int) {
		var action:ActionManager.Actions = actionManager.getAction(keyCode);

		if (action == Back) {
			SetTransition(GoBack);
		}
		if (action == Confirm) {
			SetTransition(GoForward);
		}
	}
	
	public override function HandleReleaseAction(keyCode:Int) {
		// for now we don't care about key release action.
		SetTransition(Waiting);
	}
	
	public override function Resize(event:Event) {
	}
	
	public override function Render(event:Event) {
		for (enemy in enemies) {
			enemy.Update();
		}
	}
	
	public function onClickStart(event:MouseEvent) {
		SetTransition(GoForward);
	}
	
	public function onClickExit(event:MouseEvent) {
		SetTransition(Exit);
	}
}

// Add class here that extends sprite and has it's own bitmap data
// This class will form the basis of enemies and player sprites.

class EnemyBlock extends Sprite {
	private var bgBitmap:Bitmap;
	public var wasPlaced:Bool;
	
	function new () {
		super();
		wasPlaced = false;
	}
	
	public function Setup(tree:BSPTree, w:Float, h:Float, maxD:Int) {
		var tries:Int = 0;
		var myW:Float = Math.random() * (maxD / 2) + (maxD / 2);

		while (!wasPlaced && (tries < 3)) {
			x = Math.random() * w;
			y = Math.random() * h;
			
			// Check if the tree can handle/place this item, else try a different set of coordinates.
			wasPlaced = tree.PlaceItem(x - (myW / 2), y - (myW / 2), myW + (myW / 2));
			++tries;  // Only try 3 times to place each item.
		}
		
		if (wasPlaced) {
			var bmpData:BitmapData = new BitmapData(Std.int(myW), Std.int(myW), 0xff00ff00);
			bgBitmap = new Bitmap(bmpData);
			bgBitmap.x = -(myW / 2);
			bgBitmap.y = -(myW / 2);
			addChild(bgBitmap);
			
			width = myW;
			height = width;
		}
	}
	
	public function Update() {
		// Now rotate this item.
		++this.rotation;
	}
	
}
