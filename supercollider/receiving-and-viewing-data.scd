"pydongui.py".runInTerminal;
// check SC's osc port (use as argument for minihiveosc
NetAddr.langPort;

(
// receive the different OSC messages from the sensor
OSCdef( \minibeedata, { |data,time,source| [data,time,source].postln; }, '/minibee/data' );
OSCdef( \minibeeinfo, { |data,time,src| [data,time,src].postln; }, '/minibee/info' );
OSCdef( \minibeestatus, { |data,time,src| [data,time,src].postln; }, '/minibee/status' );
);


(
// store minibee data in a variable
OSCdef( \minibeedata, { |data,time,source|
	~newSensorData = data.copyToEnd( 2 );
}, '/minibee/data' );
);

// check the length of the sensor data
~newSensorData.size;

// SWPlotterMonitor is a class available in the SenseWorld quark:
~plotter = SWPlotterMonitor.new( { ~newSensorData }, 100, ~newSensorData.size, 0.05 );
~plotter.start;


~plotter.stop;