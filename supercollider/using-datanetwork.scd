"pydongui.py".runInTerminal;
// check SC's osc port (use as argument for minihiveosc
NetAddr.langPort;

(
// receive the different OSC messages from the sensor
OSCdef( \minibeedata, { |data,time,source| [data,time,source].postln; }, '/minibee/data' );
OSCdef( \minibeeinfo, { |data,time,src| [data,time,src].postln; }, '/minibee/info' );
OSCdef( \minibeestatus, { |data,time,src| [data,time,src].postln; }, '/minibee/status' );
);

x = SWDataNetwork.new;
x.addExpected(1);
x.addExpected(2);

(
// store minibee data in a variable
OSCdef( \minibeedata, { |data,time,source|
	x.setData( data[1], data.copyToEnd( 2 ) );
}, '/minibee/data' );
);

// view the data via the GUI
x.makeNodeGui;
