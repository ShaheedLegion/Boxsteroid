package inspirational.designs;

import haxe.ds.BalancedTree.TreeNode;
import inspirational.designs.GameStatePlay.DummyItem;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * The playing game state. This class will deal with all game-specific logic.
 * @author Shaheed Abdol
 */

class GameStatePlay extends GameState
{
	private var bspTree:BSPTree;
	private var bgBitmap:Bitmap;
	private var enemies:Array<EnemyBlock>;
	
	//private var dummyItem:DummyItem;
	
	public function new(w:Int, h:Int, actionMan:ActionManager) 
	{
		super(w, h, actionMan);
		
		var bmpData:BitmapData = new BitmapData(w, h, 0xff3456ff);
		bgBitmap = new Bitmap(bmpData);
		addChild(bgBitmap);
		
		width = cast (screenW, Float);
		height = cast (screenH, Float);
		
		bspTree = new BSPTree(width, height);
		enemies = new Array<EnemyBlock>();
		
		for (i in 0...100) {
			var enemy:EnemyBlock = new EnemyBlock();
			addChild(enemy);
			enemies.push(enemy);
		}
	}
	
	public override function Setup(graph:Graphics) {
		for (enemy in enemies) {
			enemy.Setup(bspTree, bgBitmap.width, bgBitmap.height, 60);
		}
		
		//dummyItem = new DummyItem(bspTree);
		//addChild(dummyItem);
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
			wasPlaced = tree.PlaceItem(x + 10, y + 10, myW + 10);
			++tries;  // Only try 3 times to place each item.
		}
		
		if (wasPlaced) {
			var bmpData:BitmapData = new BitmapData(Std.int(myW), Std.int(myW), 0xff00ff00);
			bgBitmap = new Bitmap(bmpData);
			addChild(bgBitmap);
			
			width = myW;
			height = width;
		}
	}
	
}

class TreeNode {
	private var x:Float;
	private var y:Float;
	private var width:Float;
	private var height:Float;
	private var left_top:TreeNode;
	private var right_top:TreeNode;
	private var left_bottom:TreeNode;
	private var right_bottom:TreeNode;
	private var isEmpty:Bool;
	
	public function new(px:Float, py:Float, w:Float, h:Float) {
		x = px;
		y = py;
		width = w;
		height = h;
		left_top = null;
		right_top = null;
		left_bottom = null;
		right_bottom = null;
		isEmpty = true;
	}

	private function Contains(ix:Float, iy:Float, iw:Float):Bool {
		return ((ix >= x) && (iy >= y) && ((ix + iw) <= (x + width)) && ((iy + iw) <= (y + height)));
	}
	
	private function GetQuadrant(ix:Float, iy:Float, iw:Float):Int {
		// Check which quadrant this new item falls into.
		// If we are empty then just check for equal quadrants
		if (isEmpty) {
			var centerX:Float = x + (width / 2);
			var centerY:Float = y + (height / 2);
			
			if (ix + iw <= centerX && (ix >= x)) {	// somewhere on the left of the screen.
				if (iy + iw <= centerY && (iy >= y))
					return 0;  // top left
				if (iy + iw >= centerY && ((iy + iw) <= (y + height)))
					return 3;  // bottom left
			} else if (ix + iw >= centerX && ((ix + iw) <= (x + width))) {	//somewhere on the right of the screen.
				if (iy + iw <= centerY && (iy >= y))
					return 1;  // top right
				if (iy + iw >= centerY && ((iy + iw) <= (y + height)))
					return 2;  // bottom right
			}
			return 4;  // doesn't fit anywhere.
		}
		
		if (left_top != null) { if (left_top.Contains(ix, iy, iw)) return 0; }
		if (right_top != null) { if (right_top.Contains(ix, iy, iw)) return 1; }
		if (right_bottom != null) { if (right_bottom.Contains(ix, iy, iw)) return 2; }
		if (left_bottom != null) { if (left_bottom.Contains(ix, iy, iw)) return 3; }
		
		return 4;
	}

	private function Emplace(tn:TreeNode, ix:Float, iy:Float, iw:Float):TreeNode {
		if (tn != null) {
			if (tn.isEmpty && tn.Contains(ix, iy, iw))
				return tn;
				
			var node:TreeNode = Emplace(tn.left_top, ix, iy, iw);
			if (node != null) return node;
			
			node = Emplace(tn.right_top, ix, iy, iw);
			if (node != null) return node;

			node = Emplace(tn.right_bottom, ix, iy, iw);
			if (node != null) return node;
			
			node = Emplace(tn.left_bottom, ix, iy, iw);
			if (node != null) return node;
		}
		return null;
	}
	public function PlaceItem(ix:Float, iy:Float, iw:Float):Bool {
		if (isEmpty) {
			var polyQuad:Int = GetQuadrant(ix, iy, iw);
			if (polyQuad == 4)  // Could not find quadrant.
				return false;

			left_top = new TreeNode(x, y, ix + iw, iy + iw);
			if (polyQuad == 0) left_top.isEmpty = false;
			
			right_top = new TreeNode(x + ix + iw, y, width - (ix + iw), iy + iw);
			if (polyQuad == 1) right_top.isEmpty = false;
			
			right_bottom = new TreeNode(x + ix + iw, y + iy + iw, width - (ix + iw), height - (iy + iw));
			if (polyQuad == 2) right_bottom.isEmpty = false;
			
			left_bottom = new TreeNode(x, y + iy + iw, ix + iw, height - (iy + iw));
			if (polyQuad == 3) left_bottom.isEmpty = false;

			isEmpty = false;
			return true;
		}

		var placementNode:TreeNode = Emplace(left_top, ix, iy, iw);
		if (placementNode != null) { return placementNode.PlaceItem(ix, iy, iw); }
		
		placementNode = Emplace(right_top, ix, iy, iw);
		if (placementNode != null) { return placementNode.PlaceItem(ix, iy, iw); }
		
		placementNode = Emplace(right_bottom, ix, iy, iw);
		if (placementNode != null) { return placementNode.PlaceItem(ix, iy, iw); }
				
		placementNode = Emplace(left_bottom, ix, iy, iw);
		if (placementNode != null) { return placementNode.PlaceItem(ix, iy, iw); }
		
		return false;
		/*
		// This node is not empty (contains some poly somewhere)
		// Check if we can still fit the poly somewhere.
		switch (polyQuad) {
		case 0:
			if (left_top != null && left_top.isEmpty)
				return left_top.PlaceItem(ix, iy, iw);
		case 1:
			if (right_top != null && right_top.isEmpty)
				return right_top.PlaceItem(ix, iy, iw);
		case 2:
			if (right_bottom != null && right_bottom.isEmpty)
				return right_bottom.PlaceItem(ix, iy, iw);
		case 3:
			if (left_bottom != null && left_bottom.isEmpty)
				return left_bottom.PlaceItem(ix, iy, iw);
		}

		return false;
		*/
	}
	
	public function DrawTree(graph:Graphics, col:Int) {
		if (isEmpty)
			return;

		graph.lineStyle(2, col, 1);
		var diff:Int = 0x222222;
		if (left_top != null && !left_top.isEmpty)
		{
			graph.drawRect(left_top.x, left_top.y, left_top.width, left_top.height);
			left_top.DrawTree(graph, col - diff);
		}
		if (right_top != null && !right_top.isEmpty)
		{
			graph.drawRect(right_top.x, right_top.y, right_top.width, right_top.height);
			right_top.DrawTree(graph, col - diff);
		}
		if (right_bottom != null && !right_bottom.isEmpty)
		{
			graph.drawRect(right_bottom.x, right_bottom.y, right_bottom.width, right_bottom.height);
			right_bottom.DrawTree(graph, col - diff);
		}
		if (left_bottom != null && !left_bottom.isEmpty)
		{
			graph.drawRect(left_bottom.x, left_bottom.y, left_bottom.width, left_bottom.height);
			left_bottom.DrawTree(graph, col - diff);
		}
	}
}
class BSPTree {
	private var root:TreeNode;

	public function new (w:Float, h:Float) {
		root = new TreeNode(0, 0, w, h);
	}

	public function PlaceItem(x:Float, y:Float, w:Float):Bool {
		return root.PlaceItem(x, y, w);
	}
	
	public function DrawTree(graphObj:Graphics) {
		root.DrawTree(graphObj, 0xffffff);
	}
}

class DummyItem extends Sprite {
	public function new(bspTree:BSPTree) {
		super();
		bspTree.DrawTree(this.graphics);
	}
}