MFilter { // superclass for all filters

	var <value;
	var <input;
	var <initialisationValue;

	*new{ |initValue|
		^super.new.init( initValue );
	}

	init{ |initValue|
		// here parameters would be initialised
		value = initValue ? 0;
		initialisationValue = value;
	}

	value_{ |v|
		input = v;
		value = input; // here the filter calculation would be
		^value;
	}

	dif { // difference input - filtered input
		^(input-value);
	}

	// reset initalisation value and set value to it
	initValue_{ |v|
		initialisationValue = v;
		value = v;
	}

	// reset to initalisation value
	reset{
		value = initialisationValue;
	}

}

MSmooth : MFilter {

	var <alpha;
	var alphaInv;

	*new{ |alpha,initValue|
		^super.new.init(alpha, initValue);
	}

	init{ |a,initValue|
		alpha = a ? 0.99;
		alphaInv = 1 - alpha;
		value = initValue ? 0;
		initialisationValue = value;
	}

	alpha_{ |a|
		alpha = a ? alpha;
		alphaInv = 1 - alpha;
	}

	value_{ |v|
		input = v;
		value = (alpha*input) + (alphaInv*value); // here the filter calculation would be
		^value;
	}

}

MSmoothUD : MFilter {

	var <alphaUp;
	var alphaUpInv;
	var <alphaDown;
	var alphaDownInv;

	*new{ |alpha,initValue|
		^super.new.init(alpha, initValue);
	}

	init{ |a,initValue|
		alphaUp = a ? 0.99;
		alphaUpInv = 1 - alphaUp;
		alphaDown = a ? 0.99;
		alphaDownInv = 1 - alphaDown;

		value = initValue ? 0;
		initialisationValue = value;
	}

	alphaUp_{ |a|
		alphaUp = a ? alphaUp;
		alphaUpInv = 1 - alphaUp;
	}

	alphaDown_{ |a|
		alphaDown = a ? alphaDown;
		alphaDownInv = 1 - alphaDown;
	}

	value_{ |v|
		input = v;
		value = input.collect{ |in,i|
			// [in,i].postln;
			if ( in > value[i] ){
				(alphaUp*in) + (alphaUpInv*value[i]);
			}{
				(alphaDown*in) + (alphaDownInv*value[i]);
			}
		};
		^value;
	}

}

MHighPass : MFilter {

	var <alpha;
	var <beta;
	var <gamma;

	*new{ |gamma,alpha,beta, initValue|
		^super.new.init(gamma,alpha,beta, initValue);
	}

	init{ |c,a,b,initValue|
		gamma = c ? 0.99;
		alpha = a ? 1;
		beta = b ? 1;

		value = initValue ? 0;
		initialisationValue = value;
		input = initialisationValue;
	}

	alpha_{ |a|
		alpha = a ? alpha;
	}

	beta_{ |b|
		beta = b ? beta;
	}

	gamma_{ |c|
		gamma = c ? gamma;
	}

	value_{ |v|
		value = (alpha*v) - (beta*input) + (alpha*value);
		input = v;
		^value;
	}

}

MLeaky : MFilter {

	var <alpha;
	var <gamma;

	var <>min;
	var <>max;

	*new{ |gamma,alpha,initValue|
		^super.new.init(gamma,alpha, initValue);
	}

	init{ |c,a,initValue|
		gamma = c ? 0.99;
		alpha = a ? 1;
		value = initValue ? 0;
		initialisationValue = value;
	}

	alpha_{ |a|
		alpha = a ? alpha;
	}

	gamma_{ |c|
		gamma = c ? gamma;
	}

	value_{ |v|
		input = v;
		value = (alpha*input) + (gamma*value);
		if ( min.notNil ){
			value = value.max(min);
		};
		if ( max.notNil ){
			value = value.min(max);
		};
		^value;
	}

}
