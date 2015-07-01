package inspirational.designs;

import inspirational.designs.ActionManager;
import inspirational.designs.StateManager.GameStateManager;
import inspirational.designs.Transition.Transitions;
import openfl.display.DisplayObject;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.system.System;

/**
 * ...
 * @author Shaheed Abdol
 */

class GameStateManager extends Sprite
{
	private var actionMan:ActionManager;
	private var gameStates:Array<GameState>;
	private var currentState:Int;

	public function new(w:Int, h:Int) 
	{
		super();
		
		actionMan = new ActionManager();
		// Create the different game states and program the interactions between them.
		gameStates = new Array<GameState>();
		currentState = 0;	//point to the first game state.
		
		gameStates.push(new GameStateMenu(w, h, actionMan));
		
		Sys.println("Adding game state - " + gameStates[currentState]);
		
		addChild(gameStates[currentState]);
		
		/*
		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 15, 100);
		this.graphics.endFill();
		*/
	}
	
	public function setup(event:Event, stageObj:DisplayObject) {
		stageObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stageObj.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		Sys.println("Setup StateManager - " + currentState + ":" + gameStates.length);
		if (currentState >= 0 && currentState < gameStates.length) {
			// First pass the action on to the game state.
			
			Sys.println("Calling setup on gamestate menu");
			gameStates[currentState].Setup(this.graphics);
		}
	}

	private function keyDown(event:KeyboardEvent):Void {
		if (currentState >= 0 && currentState < gameStates.length) {
			// First pass the action on to the game state.
			gameStates[currentState].HandleEventAction(event.keyCode);

			var transition:Transitions = gameStates[currentState].GetTransitionState();
			
			if (transition == GoBack) {
				// Check if we can manage to 'pop' an item from the hypothetical backstack.
				if (currentState - 1 < 0)
					System.exit(0);
				else 
					--currentState;
			} else if (transition == GoForward) {
				if (currentState + 1 > gameStates.length - 1)
					currentState = 0;
				else
					System.exit(0);
			}
		}
	}
	
	private function keyUp(event:KeyboardEvent):Void {
		if (currentState >= 0 && currentState < gameStates.length) {
			gameStates[currentState].HandleReleaseAction(event.keyCode);
		}
	}
	
	public function resize(event:Event) {
		if (currentState >= 0 && currentState < gameStates.length) {
			gameStates[currentState].Resize(event);
		}
	}
	
	public function render(event:Event) {
		if (currentState >= 0 && currentState < gameStates.length) {
			gameStates[currentState].Render(event);
		}
	}
}