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
	// Nice, simple additive synth stolen from Stanford SC "gentle introduction"
	var snd = Mix.fill(12, {arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq, mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		Out.ar(out, snd);
	}
).add;
)


(
// Lowest versions of these notes on standard tuning guitar in HZ
var e = 82, f = 87, fSharp = 46, g = 98, gSharp = 104, a = 110, aSharp = 58, b = 62, c = 131, cSharp = 139, d = 147, dSharp = 156;

// Function to play a drone with root, fifth, octave, and twelfth; cheated with Copilot to figure this out.
~playDroneChord = { arg root = 82, out=0;
    var fifth = (2 ** (7/12)) * root;
    var octave = root * 2;
    var twelfth = fifth * 2;

    [
        [root, rrand(1.0, 4.0), rrand(2.0, 5.0)],
        [fifth, rrand(1.0, 4.0), rrand(3.0, 5.0)],
        [octave, rrand(1.0, 4.0), rrand(3.0, 5.0)],
        [twelfth, rrand(1.0, 4.0), rrand(3.0, 5.0)]
    ].do { |params|
        var freq = params[0], pause = params[1], sus = params[2];
        Pbind(
            \instrument, "drone",
            \freq, freq,
            \pause, pause,
            \sus, sus,
            \dur, pause + sus + 5,
            \out, out
        ).play;
    };
};

~playDroneChord.(e, 0);
~playDroneChord.(a, 1);
)

// Guitar playthrough
(
Synth("audioIn");
)