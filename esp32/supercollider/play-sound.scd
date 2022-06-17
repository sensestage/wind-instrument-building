s.meter;
s.freqscope;


a = Synth.new( \resonzPulse );

(
~acc2Freq = ControlSpec.new( 400, 3200, 2 ); // the range for the filter frequency
x.at( \smoothAccelero ).action.add( \controlSynth,
	{ |data|
		a.set( \freq, ~acc2Freq.map( data ) );
	}
);
);

(
~angle2Rate = ControlSpec.new( 12, 120, \exp, 1 ); // the range for the pulse frequency
x.at( \smoothAngles ).action.add( \controlSynth,
	{ |data|
		a.set( \rate, ~angle2Rate.map( data ) );
	}
);
);

(
~gyro2Amp = [0.1,1.5,-2].asSpec;
x.at( \smoothGyro ).action.add( \controlsynth, { |data|
	a.set( \amps, ~gyro2Amp.map( data ) );
} );
);

(
~tailRange = [0.6, 1,-3].asSpec;
~tail2Width = [0.1,0.9,-2].asSpec;
x.at( \smoothAnalog ).action.add( \controlsynth, { |data|
	a.set( \width, data[1].dup(3).specMap( ~tailRange, ~tail2Width ) );
} );
);

(
~tailVarRange = [0.00005, 0.02, 3].asSpec; // experiment with these ranges
~tail2Rq = [0.1,0.02,-3].asSpec;
x.at( \meanVarAnalog ).action.add( \controlsynth, { |data|
	//data.postln;
	a.set( \rq, data[1].specMap( ~tailVarRange, ~tail2Rq ) );

} );
);

a.set( \onoff, 1 );

a.set( \onoff, 0 );
