// DataNetwork is a generic hub for storing data, it is available in the Quark DataNetwork

// each set of data is stored in a datanode, that can have different slots. These datanodes can be accessed by number, or by label.

(
x = SWDataNetwork.new;       // define the network
x.addExpected(1,'analog');   // define datanode for analog data
x.addExpected(2,'accelero'); // define datanode for accelerometer data
x.addExpected(3,'gyro');     // define datanode for gyroscope data
x.addExpected(4,'angles');   // define datanode for angle data
);

// Put the data from the OSC messages on the datanetwork:
(
OSCdef( \analog, { |data,time,source| x.setData( 1, data.copyToEnd( 1 ) ); }, '/analog' );
OSCdef( \accelero, { |data,time,source| x.setData( 2, data.copyToEnd( 1 ) ); }, '/accelero' );
OSCdef( \gyro, { |data,time,source| x.setData( 3, data.copyToEnd( 1 ) ); }, '/gyro' );
OSCdef( \angles, { |data,time,source| x.setData( 4, data.copyToEnd( 1 ) ); }, '/angles' );
);

// view the data via the GUI
x.makeNodeGui;

// add an action to determine what should happen with the data:

x[\analog].action = { |data| data.postln; };

// for example adapting the range:
~anaRanges = [ [0.3, 0.9], [0.3, 0.9], [0.1,0.9], [0.3,0.9] ].collect{ |it| it.asSpec; };

x.addExpected( 11, 'analogScaled' );
x[\analog].action = { |data| x.setData( 11, data.collect{ |it,i| ~anaRanges[i].unmap( it ) } ) };

(
~accelRange = [ -2, 2].asSpec;
x.addExpected( 12, 'acceleroScaled' );
x[\accelero].action = { |data| x.setData( 12, ~accelRange.unmap( data ) ) };

~gyroRange = [ -600, 600].asSpec;
x.addExpected( 13, 'gyroScaled' );
x[\gyro].action = { |data| x.setData( 13, ~gyroRange.unmap( data ) ) };

~angleRange = [ -180.0, 180.0].asSpec;
x.addExpected( 14, 'anglesScale' );
x[\angles].action = { |data| x.setData( 14, ~angleRange.unmap( data ) ) };
);