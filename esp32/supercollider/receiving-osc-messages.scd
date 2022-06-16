(
// receive the different OSC messages from the sensor
OSCdef( \analog, { |data,time,source| [data,time,source].postln; }, '/analog' );
OSCdef( \accelero, { |data,time,src| [data,time,src].postln; }, '/accelero' );
OSCdef( \gyro, { |data,time,src| [data,time,src].postln; }, '/gyro' );
OSCdef( \angles, { |data,time,src| [data,time,src].postln; }, '/angles' );
);

/// Viewing data with SWPlotterMonitor (from SenseWorld quark)

(
// store minibee data in a variable
OSCdef( \analog, { |data,time,source| ~analogData = data.copyToEnd( 1 ); }, '/analog' );
OSCdef( \accelero, { |data,time,source| ~accelData = data.copyToEnd( 1 ); }, '/accelero' );
OSCdef( \gyro, { |data,time,source| ~gyroData = data.copyToEnd( 1 ); }, '/gyro' );
OSCdef( \angles, { |data,time,source| ~angleData = data.copyToEnd( 1 ); }, '/angles' );
);


// SWPlotterMonitor is a class available in the SenseWorld quark:

~analogPlotter = SWPlotterMonitor.new( { ~analogData }, 100, ~analogData.size, 0.025 );
~analogPlotter.start;
// stop the plotting
~analogPlotter.stop;

~accelPlotter = SWPlotterMonitor.new( { ~accelData }, 100, ~accelData.size, 0.025 );
~accelPlotter.start;
// stop the plotting
~accelPlotter.stop;

~gyroPlotter = SWPlotterMonitor.new( { ~gyroData }, 100, ~gyroData.size, 0.025 );
~gyroPlotter.start;
// stop the plotting
~gyroPlotter.stop;

~anglePlotter = SWPlotterMonitor.new( { ~angleData }, 100, ~angleData.size, 0.025 );
~anglePlotter.start;
// stop the plotting
~anglePlotter.stop;


