MThresholdTrigger {
	var <prevValue;
	var <direction;
	var <trigDirection;
	var <canTrigger = true;

	var <>threshold;
	var <>action;

	*new{ |threshold, triggerDirection, curValue=0|
		^super.new.init( threshold, triggerDirection, curValue );
	}

	init{ |thresh, triggerDirection, curV|
		prevValue = curV;
		threshold = thresh;
		trigDirection = triggerDirection;
	}

	value{ |newval|
		var prevDir = direction;
		if ( newval > prevValue ){
			direction = \up;
		}{
			direction = \down;
		};
		if ( prevDir != direction ){ // direction of signal changed
			if ( direction == trigDirection ){
				canTrigger = true;
			};
		};
		if ( newval > threshold and: canTrigger ){
			action.value( newval );
			canTrigger = false;
		};
		prevValue = newval;
	}


}