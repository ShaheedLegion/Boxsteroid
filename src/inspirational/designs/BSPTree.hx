package inspirational.designs;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/*
 * @Author: Shaheed Abdol - 2015
 * BSPTree class, provides minimal support for binary space partitioning into quads.
 * */

class TreeNode {
	private var rectangle:Rectangle;
	private var left_top:TreeNode;
	private var right_top:TreeNode;
	private var left_bottom:TreeNode;
	private var right_bottom:TreeNode;
	private var isEmpty:Bool;
	
	public function new(rect:Rectangle) {
		rectangle = rect;
		left_top = null;
		right_top = null;
		left_bottom = null;
		right_bottom = null;
		isEmpty = true;
	}
	
	private function GetQuadrant(rect:Rectangle):Int {
		// Check which quadrant this new item falls into.
		// If we are empty then just check for equal quadrants
		if (isEmpty) {
			// Top-left
			var comparison:Rectangle = new Rectangle(rectangle.left, rectangle.top, rectangle.width / 2, rectangle.height / 2);
			if (comparison.containsRect(rect))
				return 0;
			
			// Top-right
			comparison.setTo(rectangle.left + (rectangle.width / 2), rectangle.top, rectangle.width / 2, rectangle.height / 2);
			if (comparison.containsRect(rect))
				return 1;
				
			// Bottom-right
			comparison.setTo(rectangle.left + (rectangle.width / 2), rectangle.top + (rectangle.height / 2), rectangle.width / 2, rectangle.height / 2);
			if (comparison.containsRect(rect))
				return 2;
				
			// Bottom-left
			comparison.setTo(rectangle.left, rectangle.top + (rectangle.height / 2), rectangle.width / 2, rectangle.height / 2);
			if (comparison.containsRect(rect))
				return 3;
				
			return 4;
		}
		
		if (left_top != null) { if (left_top.rectangle.containsRect(rect)) return 0; }
		if (right_top != null) { if (right_top.rectangle.containsRect(rect)) return 1; }
		if (right_bottom != null) { if (right_bottom.rectangle.containsRect(rect)) return 2; }
		if (left_bottom != null) { if (left_bottom.rectangle.containsRect(rect)) return 3; }
		
		return 4;
	}

	private function Emplace(tn:TreeNode, ix:Float, iy:Float, iw:Float):TreeNode {
		if (tn != null) {
			if (tn.isEmpty && tn.rectangle.containsRect(new Rectangle(ix, iy, iw, iw)))
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
		var r:Rectangle = new Rectangle(ix, iy, iw, iw);
		if (isEmpty) {
			var polyQuad:Int = GetQuadrant(r);
			if (polyQuad == 4)  // Could not find quadrant.
				return false;

			switch (polyQuad) {
				case 0:  // Top-left
					left_top = new TreeNode(new Rectangle(rectangle.left, rectangle.top, (r.left - rectangle.left) + r.width, (r.top - rectangle.top) + r.height));
					left_top.isEmpty = false;
					right_top = new TreeNode(new Rectangle(r.left + r.width, rectangle.top, rectangle.width - ((r.left - rectangle.left) + r.width), (r.top - rectangle.top) + r.height));
					right_bottom = new TreeNode(new Rectangle(rectangle.left + r.width, r.top + r.height, rectangle.width - ((r.left - rectangle.left) + r.width), rectangle.height - ((r.top - rectangle.top) + r.height)));
					left_bottom = new TreeNode(new Rectangle(rectangle.left, r.top + r.height, (r.left - rectangle.left) + r.width, rectangle.height - ((r.top - rectangle.top) + r.height)));
			
				case 1:  // Top-right
					left_top = new TreeNode(new Rectangle(rectangle.left, rectangle.top, r.left - rectangle.left, (r.top - rectangle.top) + r.height));
					right_top = new TreeNode(new Rectangle(r.left, rectangle.top, rectangle.width - (r.left - rectangle.left), (r.top - rectangle.top) + r.height));
					right_top.isEmpty = false;
					right_bottom = new TreeNode(new Rectangle(r.left, r.top + r.height, rectangle.width - (r.left - rectangle.left), rectangle.height - ((r.top - rectangle.top) + r.height)));
					left_bottom = new TreeNode(new Rectangle(rectangle.left, r.top + r.height, r.left - rectangle.left, rectangle.height - ((r.top - rectangle.top) + r.height)));
			
				case 2:  // Bottom-right
					left_top = new TreeNode(new Rectangle(rectangle.left, rectangle.top, r.left - rectangle.left, r.top - rectangle.top));
					right_top = new TreeNode(new Rectangle(r.left, rectangle.top, rectangle.width - (r.left - rectangle.left), r.top - rectangle.top));
					right_bottom = new TreeNode(new Rectangle(r.left, r.top, rectangle.width - (r.left - rectangle.left), rectangle.height - (r.top - rectangle.top)));
					right_bottom.isEmpty = false;
					left_bottom = new TreeNode(new Rectangle(rectangle.left, r.top, r.left - rectangle.left, rectangle.height - (r.top - rectangle.top)));
			
				
				case 3:  // Bottom-left
					left_top = new TreeNode(new Rectangle(rectangle.left, rectangle.top, (r.left - rectangle.left) + r.width, r.top - rectangle.top));
					right_top = new TreeNode(new Rectangle(r.right + r.width, rectangle.top, rectangle.width - ((r.left - rectangle.left) + r.width), r.top - rectangle.top));
					right_bottom = new TreeNode(new Rectangle(r.right + r.width, r.top, rectangle.width - ((r.left - rectangle.left) + r.width), rectangle.height - (r.top - rectangle.top)));
					left_bottom = new TreeNode(new Rectangle(rectangle.left, r.top, (r.left - rectangle.left) + r.width, rectangle.height - (r.top - rectangle.top)));
					left_bottom.isEmpty = false;
			}

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
	}
	
	public function DrawTree(graph:Graphics, col:Int) {
		if (isEmpty)
			return;

		var diff:Int = 0x222222;
		if (left_top != null && !left_top.isEmpty)
		{
			graph.lineStyle(2, col, 1);
			graph.drawRect(left_top.rectangle.x, left_top.rectangle.y, left_top.rectangle.width, left_top.rectangle.height);
			left_top.DrawTree(graph, col - diff);
		}
		if (right_top != null && !right_top.isEmpty)
		{
			graph.lineStyle(2, col, 1);
			graph.drawRect(right_top.rectangle.x, right_top.rectangle.y, right_top.rectangle.width, right_top.rectangle.height);
			right_top.DrawTree(graph, col - diff);
		}
		if (right_bottom != null && !right_bottom.isEmpty)
		{
			graph.lineStyle(2, col, 1);
			graph.drawRect(right_bottom.rectangle.x, right_bottom.rectangle.y, right_bottom.rectangle.width, right_bottom.rectangle.height);
			right_bottom.DrawTree(graph, col - diff);
		}
		if (left_bottom != null && !left_bottom.isEmpty)
		{
			graph.lineStyle(2, col, 1);
			graph.drawRect(left_bottom.rectangle.x, left_bottom.rectangle.y, left_bottom.rectangle.width, left_bottom.rectangle.height);
			left_bottom.DrawTree(graph, col - diff);
		}
	}
}

class BSPTree {
	private var root:TreeNode;

	public function new (rect:Rectangle) {
		root = new TreeNode(rect);
	}

	public function PlaceItem(x:Float, y:Float, w:Float):Bool {
		return root.PlaceItem(x, y, w);
	}
	
	public function DrawTree(graphObj:Graphics) {
		root.DrawTree(graphObj, 0xffffff);
	}
}

class TreeVisualizer extends Sprite {
	public function new(bspTree:BSPTree) {
		super();
		bspTree.DrawTree(this.graphics);
	}
}