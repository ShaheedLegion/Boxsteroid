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
 * This class manages a hypothetical 'backstack' which contains the history of child controls added to it.
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
		gameStates.push(new GameStatePlay(w, h, actionMan));
		addChild(gameStates[currentState]);
	}
	
	public function setup(event:Event, stageObj:DisplayObject) {
		stageObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stageObj.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		if (currentState >= 0 && currentState < gameStates.length) {
			gameStates[currentState].Setup(this.graphics);
		}
	}

	private function keyDown(event:KeyboardEvent):Void {
		if (currentState >= 0 && currentState < gameStates.length) {
			// First pass the action on to the game state.
			gameStates[currentState].HandleEventAction(event.keyCode);
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
			var transition:Transitions = gameStates[currentState].GetTransitionState();
			HandleTransition(transition);
			gameStates[currentState].Render(event);
		}
	}
	
	public function HandleTransition(transition:Transitions) {
		if (transition == GoBack) {
			// Check if we can manage to 'pop' an item from the hypothetical backstack.
			if (currentState - 1 < 0)
				System.exit(0);
			else {
				removeChild(gameStates[currentState]);
				gameStates[currentState].GameStateRemoved();
				--currentState;
				addChild(gameStates[currentState]);
			}
		} else if (transition == GoForward) {
			if (currentState + 1 > gameStates.length - 1) {
				removeChild(gameStates[currentState]);
				gameStates[currentState].GameStateRemoved();
				currentState = 0;
				addChild(gameStates[currentState]);
			}
			else {
				removeChild(gameStates[currentState]);
				gameStates[currentState].GameStateRemoved();
				++currentState;
				addChild(gameStates[currentState]);
			}
		} else if (transition == Exit) {
			System.exit(0);
		}
	}
}