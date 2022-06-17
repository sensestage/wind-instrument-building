(
SynthDef( \resonzPulse, { |out=0|
	var snd = Resonz.ar(
		LFPulse.ar(
			\rate.kr( [400,400,400],0.05),
			width: \width.kr( [0.5,0.5,0.5], 0.2 ) ),
		\freq.kr( [3000,3000,3000],0.05) * [1,5/4,4/5], //.dup * [1,4/3,3/4],
		\rq.kr(0.05,0.1),
		\amps.kr( [0.1,0.1,0.1], 0.1 ).lagud( \ampupLag.kr(0.2), \ampdownLag.kr(2) ), // .dup * [1,1/3,1/3]
	).sum; // .sum;
	//snd = AllpassN.ar( snd, 0.2, \delay.kr(0.1), \decay.kr(0.5) );
	snd = RLPF.ar( snd, (\freq.kr * 4).min(20000), \lrq.kr(0.5) );
	snd = LeakDC.ar( snd );
	//snd = FreeVerb.ar( snd, \mix.kr(0.5), \room.kr(0.3), \damp.kr(0.6) );
	Out.ar( out,
		Pan2.ar( snd, \pos.kr(0),
			\onoff.kr(0,10) *
			EnvGen.kr(  Env.asr(2, 1, \releaseTime.kr(5), -2), \gate.kr(1), doneAction: 2 )
		)
	);
}).add;
);

(
SynthDef( \resonzVarsaw, { |out=0|
	Out.ar( out,
		Pan2.ar(
			Resonz.ar(
				VarSaw.ar(
					\rate.kr( [400,400,400],0.1),
					width: \width.kr( [0.5,0.5,0.5] ) ),
				\freq.kr( [3000,3000,3000],0.1) * [1,5/4,2/3], \rq.kr(0.05),
				\amps.kr( [0.1,0.1,0.1] ).lagud( \ampupLag.kr(0.2), \ampdownLag.kr(2) );
			).sum,
			\pos.kr(0),
			 EnvGen.kr( Env.asr(2, 1, \releaseTime.kr(5), -2), \gate.kr(1), doneAction: 2 )
		)
	);
}).add;
);


(
SynthDef( \resonzDust, { |out=0|
	Out.ar( out,
		Resonz.ar(
			Dust.ar( \rate.kr( [ 20, 20 ] ) ),
			\freq.kr( [3000,3000],0.1) * [1,5/4], \rq.kr(0.05),
			\amps.kr( [0.1,0.1] ).lagud( \ampLagUp.kr(0.1), \ampLagDown.kr(2) );
		)
		* EnvGen.kr(  Env.asr(2, 1, \releaseTime.kr(5), -2), \gate.kr(1), doneAction: 2 )
	);
}).add;
);

(
SynthDef( \resonzNoise, { |out=0|
	var dustrate = \rate.kr( [ 20, 20 ] );
	var envdur = \dur.kr(1) / dustrate;
	Out.ar( out,
		Array.fill(2, {
			Resonz.ar(
				WhiteNoise.ar(1),
				\freq.kr( [3000,3000],0.1) * [1,5/4],
				\rq.kr( [0.05,0.05], 0.1),
				\amps.kr( [0.1,0.1] ).lagud( \ampLagUp.kr(0.1), \ampLagDown.kr(2) );
			)
			* EnvGen.ar( Env.sine, Dust.ar( dustrate ), timeScale: envdur )
		}).sum
		* EnvGen.kr(  Env.asr(2, 1, \releaseTime.kr(5), -2), \gate.kr(1), doneAction: 2 )
	);
}).add;
);


(
SynthDef( \sineFMAM, { |out=0|
	Out.ar( out,
		Pan2.ar(
			(
				SinOsc.ar(
					\freq.kr( [3000,3000,3000],0.1) * [1,5/4,2/3]
					* SinOsc.ar( \ffreq.kr( [10,10,10],0.1 ), 0, \fmmul.kr(0.1), 1 ),
					0,
					SinOsc.ar( \afreq.kr( [20,20,20], 0.1), 0, \ammul.kr(0.1), 1 )
				) * \amps.kr( [0.1,0.1,0.1] ).lagud( \ampupLag.kr(0.2), \ampdownLag.kr(2) ) * 0.1
			).sum,
		\pos.kr(0),
		EnvGen.kr(  Env.asr(2, 1, \releaseTime.kr(5), -2), \gate.kr(1), doneAction: 2 )
	)
	)
}).add;
);


(
SynthDef( \sineFMAMPerc, { |out=0|
	var snd = SinOsc.ar(
		\freq.kr( [3000,3000,3000],0.1),
		//* SinOsc.ar( \ffreq.kr( [10,10,10],0.1 ), 0, \fmmul.kr(0.1), 1 ),
		0,
		SinOsc.ar( \afreq.kr( [20,20,20], 0.1), 0, \ammul.kr(0.1), 1 )
	);
	Out.ar( out,
		Pan2.ar( snd.sum * 0.1, \pos.kr(0), EnvGen.kr(  Env.perc(\attack.kr(0.1), \releaseTime.kr(5)), \gate.kr(1), doneAction: 2 ) )
	);
}).add;
)
