(
x[\anglesScaled].action = MFunc.new;

x.addExpected( 24, \smoothAngles, 3 );
x.at( \smoothAngles ).action = MFunc.new;
x.addExpected( 34, \variationAngles, 3 );
x.at( \variationAngles ).action = MFunc.new;
x.addExpected( 44, \meanVarAngles, 3 );
x.at( \meanVarAngles ).action = MFunc.new;
);

(
~factorAngles = 0.1;
x.at( \anglesScaled ).action.add( \expMean, { |data|
	x.setData( 24, ([data, x.at( \smoothAngles ).data]*[~factorAngles, 1-~factorAngles]).sum; );
	x.setData( 34, (data - x.at( \smoothAngles ).data).abs.pow(2) );
});
);

(
~factorVarAngles = 0.35;
x.at( \variationAngles ).action.add( \expMean, { |data|
	x.setData( 44, ([data, x.at( \meanVarAngles ).data]*[~factorVarAngles, 1-~factorVarAngles]).sum; );
});
);

