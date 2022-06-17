(
x[\analogScaled].action = MFunc.new;

x.addExpected( 21, \smoothAnalog, 4 );
x.at( \smoothAnalog ).action = MFunc.new;
x.addExpected( 31, \variationAnalog, 4 );
x.at( \variationAnalog ).action = MFunc.new;
x.addExpected( 41, \meanVarAnalog, 4 );
x.at( \meanVarAnalog ).action = MFunc.new;
);

(
~factor = 0.1;
x.at( \analogScaled ).action.add( \expMean, { |data|
	x.setData( 21, ([data, x.at( \smoothAnalog ).data]*[~factor, 1-~factor]).sum; );
	x.setData( 31, (data - x.at( \smoothAnalog ).data).abs.pow(2) );
});
);

(
~factorVar = 0.35;
x.at( \variationAnalog ).action.add( \expMean, { |data|
	x.setData( 41, ([data, x.at( \meanVarAnalog ).data]*[~factorVar, 1-~factorVar]).sum; );
});
);

