(
x[\acceleroScaled].action = MFunc.new;

x.addExpected( 22, \smoothAccelero, 3 );
x.at( \smoothAccelero ).action = MFunc.new;
x.addExpected( 32, \variationAccelero, 3 );
x.at( \variationAccelero ).action = MFunc.new;
x.addExpected( 42, \meanVarAccelero, 3 );
x.at( \meanVarAccelero ).action = MFunc.new;
);

(
~factorAcc = 0.1;
x.at( \acceleroScaled ).action.add( \expMean, { |data|
	x.setData( 22, ([data, x.at( \smoothAccelero ).data]*[~factorAcc, 1-~factorAcc]).sum; );
	x.setData( 32, (data - x.at( \smoothAccelero ).data).abs.pow(2) );
});
);

(
~factorVarAcc = 0.35;
x.at( \variationAccelero ).action.add( \expMean, { |data|
	x.setData( 42, ([data, x.at( \meanVarAccelero ).data]*[~factorVarAcc, 1-~factorVarAcc]).sum; );
});
);

