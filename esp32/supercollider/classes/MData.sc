MData{

	var <value, <time;
	var <previous, <prevTime;

	var <>action;
	var <dict;

	*new{
		^super.new.init;
	}

	init{
		action = { |mb| mb.postln; };
		prevTime = Main.elapsedTime;
		dict = IdentityDictionary.new;
		time = prevTime;
	}

	value_{ |v,t|
		previous = value;
		prevTime = time;
		time = t ? Main.elapsedTime;
		value = v;
		action.value( this );
	}

	delta{
		^(value - previous);
	}

	dt{
		^(time - prevTime );
	}

	slope{
		^(this.delta / this.dt);
	}


	/// dict
	put{ |name,val|
		dict.put( name, val );
	}
	at{ |name|
		^dict.at( name );
	}

	what{
		^dict.keys;
	}


	// posting
	postAll{ |pre|
		pre.post; "\t-> ".post; this.postKeys;
		pre.post; "\t=> ".post; this.postActions;
	}

	postKeys{
		var keys = this.what.asArray.sort;
		keys.postln;
	}

	postActions{
		if ( action.isKindOf( MFunc ) ){
			action.postActions;
		}
	}

}