MStats {
	var <>rawSpec;
	var <>activitySpec;

	var <network;

	var <meannode;
	var <stddevnode;

	*new{
		^super.new.init;
	}

	initSpecs{
		rawSpec = [ 0.46, 0.54 ].asSpec;
		activitySpec = [ 0.0001, 0.15, \exponential ].asSpec;
	}

	init{
		this.initSpecs;
		network = SWDataNetwork.new;
		[
			[1,\raw],[2,\mean], [3,\stddev],
			[11, \rawMapped], [ 12, \meanMapped], [13,\stdMapped],
		].do{ |it|
			network.addExpected( it[0], it[1], 3 );
		};
		this.addHooks;
	}

	addHooks{
		network.addHook( 1, {
			network.nodes[1].action = MFunc.new;
			network.nodes[1].action.add( \map, { |data|
				network.setData( 11, rawSpec.unmap( data ) );
			});

			network.nodes[1].createBus(Server.default);

			meannode = MeanNode.new( 2, network, network.nodes[1].bus, Server.default );
			meannode.set( \length, 500 );
			fork{ 0.2.wait; meannode.start; };

			stddevnode = StdDevNode.new( 3, network, network.nodes[1].bus, Server.default );
			stddevnode.set( \length, 250 );
			fork{ 0.2.wait; stddevnode.start; };
		});
		network.addHook( 2, { // mean
			network.nodes[2].action = MFunc.new;
			network.nodes[2].action.add( \map, { |data|
				network.setData( 12, rawSpec.unmap( data ) );
			});
		});
		network.addHook( 3, { // stddev
			network.nodes[3].action = MFunc.new;
			network.nodes[3].action.add( \map, { |data|
				network.setData( 13, activitySpec.unmap( data ) );
			});
		});

		[11, 12, 13].do{ |id|
			network.addHook( id, {
				network.nodes[id].action = MFunc.new;
			});
		};
	}

	setData{ |data|
		network.setData( 1, data );
	}

	rawUni{
		^network.nodes[11].data;
	}

	meanUni{
		^network.nodes[12].data;
	}

	stdUni{
		^network.nodes[13].data;
	}

	postAll{
		var keys = this.availableKeys.asArray.sort;
		keys.postln;
		keys.do{ |it|
			it.post; "\t=> ".post;
			network.at( it ).action.postActions;
		}
	}


// --- kind of standard methods:
	addAction{ |node,label,action|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.addFirst( label, action );
		}{
			network.nodes[ node ].action.addFirst( label, action );
		};
	}

	removeAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.remove( label );
		}{
			network.nodes[ node ].action.remove( label );
		};
	}

	enableAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.enable( label );
		}{
			network.nodes[ node ].action.enable( label );
		};
	}

	disableAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.disable( label );
		}{
			network.nodes[ node ].action.disable( label );
		};
	}

	monitor{ |node,onoff|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).monitor(onoff);
		}{
			network.nodes[ node ].monitor(onoff);
		};
	}

	makeGui{
		^network.makeNodeGui;
	}

	availableKeys{
		^network.spec.map.keys
	}
}