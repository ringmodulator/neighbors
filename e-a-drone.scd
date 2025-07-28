// Define synths
(
// Guitar playthrough with EQ to help horrible peizo pickup plus reverb
SynthDef(
	"audioIn",
	{
	var in = SoundIn.ar(0);
	var lowPass = LPF.ar(in: in, freq: 1500, mul: 3);
	var reverb = FreeVerb.ar(in: lowPass, mix: 0.33, room: 0.7, damp: 0.5);
	Out.ar ([0, 1], reverb).softclip;
	}
).add;

// Drone instrument
SynthDef(
	"drone",
	{
	arg freq = 440, amp = 0.2, pause = 1, sus = 3, out = [0, 1];
	var env = Env.new(levels: [0.001, 0.001, 1, 1, 0.001], times: [pause, 2, sus, 3], curve: \sine);
	//var env = Env.linen(2, rrand(2.0, 4.0), 3, amp, \sine);
		// Nice, simple additive synth stolen from Stanford SC "gentle introduction"
	var snd = Mix.fill(12, {arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq, mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		Out.ar(out, snd);
	}
).add;
)

// Play E-B drone

(
var e = 82, f = 87, fSharp = 46, g = 98, gSharp = 104, a = 110, aSharp = 58, b = 62, c = 131, cSharp = 139, d = 147, dSharp = 156;
var root = e;
var rootPause = rrand(1.0, 4.0);
var rootSus = rrand(2.0, 5.0);

var fifth = (2 ** (7/12)) * root; // calculate perfect 5th in equal temperament
var fifthPause = rrand(1.0, 4.0);
var fifthSus = rrand(3.0, 5.0);

var octave = root * 2;
var octavePause = rrand(1.0, 4.0);
var octaveSus = rrand(3.0, 5.0);

var twelfth = fifth * 2;
var twelfthPause = rrand(1.0, 4.0);
var twelfthSus = rrand(3.0, 5.0);

Pbind (
	\instrument, "drone",
	\freq, root,
	\pause, rootPause,
	\sus, rootSus,
	\dur, rootPause + rootSus + 5,
	\out, 0
).play;

Pbind (
	\instrument, "drone",
	\freq, fifth,
	\pause, fifthPause,
	\sus, fifthSus,
	\dur, fifthPause + fifthSus + 5,
	\out, 0
).play;

Pbind (
	\instrument, "drone",
	\freq, octave,
	\pause, octavePause,
	\sus, octaveSus,
	\dur, octavePause + octaveSus + 5,
	\out, 0
).play;

Pbind (
	\instrument, "drone",
	\freq, twelfth,
	\pause, twelfthPause,
	\sus, twelfthSus,
	\dur, twelfthPause + twelfthSus + 5,
	\out, 0
).play;
)

// A-E drone. Obviously it would be better to not just replicate this code...

(
var e = 82, f = 87, fSharp = 46, g = 98, gSharp = 104, a = 110, aSharp = 58, b = 62, c = 131, cSharp = 139, d = 147, dSharp = 156;
var root = a;
var rootPause = rrand(1.0, 4.0);
var rootSus = rrand(2.0, 5.0);

var fifth = (2 ** (7/12)) * root; // calculate perfect 5th in equal temperament
var fifthPause = rrand(1.0, 4.0);
var fifthSus = rrand(3.0, 5.0);

var octave = root * 2;
var octavePause = rrand(1.0, 4.0);
var octaveSus = rrand(3.0, 5.0);

var twelfth = fifth * 2;
var twelfthPause = rrand(1.0, 4.0);
var twelfthSus = rrand(3.0, 5.0);

Pbind (
	\instrument, "drone",
	\freq, root,
	\pause, rootPause,
	\sus, rootSus,
	\dur, rootPause + rootSus + 5,
	\out, 1
).play;

Pbind (
	\instrument, "drone",
	\freq, fifth,
	\pause, fifthPause,
	\sus, fifthSus,
	\dur, fifthPause + fifthSus + 5,
	\out, 1
).play;

Pbind (
	\instrument, "drone",
	\freq, octave,
	\pause, octavePause,
	\sus, octaveSus,
	\dur, octavePause + octaveSus + 5,
	\out, 1
).play;

Pbind (
	\instrument, "drone",
	\freq, twelfth,
	\pause, twelfthPause,
	\sus, twelfthSus,
	\dur, twelfthPause + twelfthSus + 5,
	\out, 1
).play;
)


// Guitar playthrough
(
Synth("audioIn");
)