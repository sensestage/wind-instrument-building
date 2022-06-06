(
// receive the different OSC messages from the sensor
OSCdef( \analog, { |data,time,source| [data,time,source].postln; }, '/analog' );
OSCdef( \accelero, { |data,time,src| [data,time,src].postln; }, '/accelero' );
OSCdef( \gyro, { |data,time,src| [data,time,src].postln; }, '/gyro' );
OSCdef( \angles, { |data,time,src| [data,time,src].postln; }, '/angles' );
);


// using DataNetwork

(
x = SWDataNetwork.new;
x.addExpected(1,'analog');
x.addExpected(2,'accelero');
x.addExpected(3,'gyro');
x.addExpected(4,'angles');
);

(
OSCdef( \analog, { |data,time,source| x.setData( 1, data.copyToEnd( 1 ) ); }, '/analog' );
OSCdef( \accelero, { |data,time,source| x.setData( 2, data.copyToEnd( 1 ) ); }, '/accelero' );
OSCdef( \gyro, { |data,time,source| x.setData( 3, data.copyToEnd( 1 ) ); }, '/gyro' );
OSCdef( \angles, { |data,time,source| x.setData( 4, data.copyToEnd( 1 ) ); }, '/angles' );
);

// view the data via the GUI
x.makeNodeGui;


