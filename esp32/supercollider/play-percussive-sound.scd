~triggerPercs = ThresholdTrigger.new( 0.001, \up, 0 );
~triggerPercs.threshold = 0.005;

~scale = Scale.dorian;

//~scale.degreeToFreq( 10, 3000, 0 );
//~scale.degrees

(
~acc2Degree = ControlSpec.new( 20, 0, \lin, 0.5 );
// ~mag2Freq2 = ControlSpec.new( 3000, 12000, \exp );
~gyro2Amp2 = [0.005,0.1,-4].asSpec;

~triggerPercs.action = { |val|
	var freqs =	~acc2Degree.map( x.at( \smoothAccelero ).data ).collect{ |it| ~scale.degreeToFreq( it, 375, 0 ) };
	// ("Trigger" + val).postln;
	Synth.new( \sineFMAMPerc, [
		\releaseTime, 0.2,
		\attack, 0.01,
		\freq, freqs,
		\afreq, freqs.rotate(1)/25,
		\ammul,0.07,
		\amps, ~gyro2Amp2.map( x.at( \smoothGyro ).data )/16
	] );
};
);

(
x.at( \variationAnalog ).action.add( \trigger, { |data|
	~triggerPercs.value( data[1] );
} );
);

