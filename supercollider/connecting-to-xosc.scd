// test xosc
NetAddr.myIP

OSCFunc.trace( true, true );
n = NetAddr.new( "127.0.0.1", 57300 );

n.sendMsg( "/hello", 1 );


n.sendMsg( "/XOSC/subscribe/host", "127.0.0.1", 57120, NetAddr.langPort );
n.sendMsg( "/hello", 1 );

n.sendMsg( "/XOSC/subscribe/tag", "/hello" );
n.sendMsg( "/hello", 1 );
n.sendMsg( "/XOSC/unsubscribe/tag", "/hello" );
