"using-datanetwork.scd".resolveRelative.load;
"processing-data-analog.scd".resolveRelative.load;
"processing-data-accelero.scd".resolveRelative.load;
"processing-data-gyro.scd".resolveRelative.load;
"processing-data-angles.scd".resolveRelative.load;

s.doWhenBooted({
	"synthdefs.scd".resolveRelative.load;
	"play-sound.scd".resolveRelative.openDocument;
	"play-percussive-sound.scd".resolveRelative.openDocument;
});
