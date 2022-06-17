(
x[\gyroScaled].action = MFunc.new;

x.addExpected( 23, \smoothGyro, 3 );
x.at( \smoothGyro ).action = MFunc.new;
x.addExpected( 33, \variationGyro, 3 );
x.at( \variationGyro ).action = MFunc.new;
x.addExpected( 43, \meanVarGyro, 3 );
x.at( \meanVarGyro ).action = MFunc.new;
);

(
~factorGyro = 0.1;
x.at( \gyroScaled ).action.add( \expMean, { |data|
	x.setData( 23, ([data, x.at( \smoothGyro ).data]*[~factorGyro, 1-~factorGyro]).sum; );
	x.setData( 33, (data - x.at( \smoothGyro ).data).abs.pow(2) );
});
);

(
~factorVarGyro = 0.35;
x.at( \variationGyro ).action.add( \expMean, { |data|
	x.setData( 43, ([data, x.at( \meanVarGyro ).data]*[~factorVarGyro, 1-~factorVarGyro]).sum; );
});
);

