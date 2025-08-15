s.boot;

// Define synths and buses
(
// Audio bus for master fader
~faderBus = Bus.audio(s, 2);

// Load boiler sound into buffer
~boiler = Buffer.read(s, "/Users/aaron/Dropbox/Music Recordings/SuperCollider/neighbors/boiler.wav");

// Guitar playthrough with EQ to help horrible peizo pickup plus reverb
SynthDef(
	"audioIn",
	{
	var in = SoundIn.ar(0);
	var lowPass = LPF.ar(in: in, freq: 1500, mul: 3);
	var reverb = FreeVerb.ar(in: lowPass, mix: 0.4, room: 0.9, damp: 0.5);
	Out.ar ([0, 1], reverb).softclip;
	}
).add;

// Drone instrument
SynthDef(
	\drone,
	{
	arg out = 0, freq = 440, amp = 0.2, pause = 1, sus = 3, pan = 1;
	var env = Env.new(levels: [0.001, 0.001, 1, 1, 0.001], times: [pause, 2, sus, 3], curve: \sine);
	// Nice, simple additive synth stolen from Stanford SC "gentle introduction"
	var snd = Mix.fill(12, {
			arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq, mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		snd = Pan2.ar(snd, SinOsc.kr(pan));
		Out.ar(out, snd);
	}
).add;

// Master envelope
SynthDef(
	\fader,
	{
		arg in = 0, gate = 1;
		var env, input;
		env = Env.asr(5, 1.0, 5, curve: 4.0).kr(gate: gate);
		input = In.ar(in, 2);
		Out.ar([0, 1], input * env)
	}
).add;

(
// Function to play a drone with root, fifth, octave, and twelfth; cheated with Copilot to figure this out.
~playDroneChord = {
	arg out = 0, root = 82;
    var fifth = (2 ** (7/12)) * root;
    var octave = root * 2;
    var twelfth = fifth * 2;

    [
		[root, rrand(1.0, 4.0), rrand(2.0, 5.0), rrand(0.1, 0.5)],
        [fifth, rrand(1.0, 4.0), rrand(3.0, 5.0), rrand(0.1, 0.5)],
        [octave, rrand(1.0, 4.0), rrand(3.0, 5.0), rrand(0.1, 0.5)],
        [twelfth, rrand(1.0, 4.0), rrand(3.0, 5.0), rrand(0.1, 0.5)]
    ].do { |params|
        var freq = params[0], pause = params[1], sus = params[2], pan = params[3];
        Pbind(
            \instrument, \drone,
			\out, out,
            \freq, freq,
            \pause, pause,
            \sus, sus,
            \dur, pause + sus + 5,
			\pan, pan
        ).play;
    };
};
)
)

(
// Start drones
// Lowest versions of these notes on standard tuning guitar in HZ
var e = 82, f = 87, fSharp = 46, g = 98, gSharp = 104, a = 110, aSharp = 58, b = 62, c = 131, cSharp = 139, d = 147, dSharp = 156;

~playDroneChord.(~faderBus, e);
~playDroneChord.(~faderBus, a);

x = Synth.new(\fader, [
	\in, ~faderBus,
	\gate, 1
]);
)

// End drone
x.release;

// Guitar playthrough
(
Synth("audioIn");
)
