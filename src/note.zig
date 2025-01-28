const math = @import("std").math;

const semitone = math.pow(f64, 2.0, 1.0 / 12.0);

pub const NoteName = enum(i8) {
    C = 0,
    Db,
    D,
    Eb,
    E,
    F,
    Gb,
    G,
    Ab,
    A,
    Bb,
    B,
    pub fn toString(self: NoteName) []const u8 {
        return switch (self) {
            .C => "C",
            .Db => "C#",
            .D => "D",
            .Eb => "Eb",
            .E => "E",
            .F => "F",
            .Gb => "F#",
            .G => "G",
            .Ab => "G#",
            .A => "A",
            .Bb => "Bb",
            .B => "B",
        };
    }
};

pub const Tone = struct {
    note: NoteName,
    octave: i8,
    pub fn frequency(self: Tone) f64 {
        const resolved_octave = self.octave - 4;
        const note_tag = @intFromEnum(self.note) - 9;
        const exponent: f64 = @floatFromInt(note_tag + (12 * resolved_octave));
        return 440.0 * math.pow(f64, semitone, exponent);
    }
};

pub fn frequency_from_rate(per_hour: f64) f64 {
    return per_hour / 3600.0;
}

pub fn tone_from_frequency(freq: f64) struct { tone: Tone, offset: f64 } {
    const base_freq = freq / 440.0;
    const raw_note = math.log(f64, semitone, base_freq);
    const rounded_note = math.round(raw_note);
    const note_offset = rounded_note - raw_note;
    const int_note: i64 = @intFromFloat(rounded_note);
    const note_type_int: i8 = @intCast(@mod(int_note + 9, 12));
    const note_type: NoteName = @enumFromInt(note_type_int);
    const octave: i8 = @intCast(@divFloor(int_note, 12) + 4);
    return .{ .tone = Tone{ .note = note_type, .octave = octave }, .offset = note_offset };
}

pub fn tone_from_rate(per_hour: f64) struct { tone: Tone, offset: f64 } {
    const tone_data = tone_from_frequency(frequency_from_rate(per_hour));
    return .{ .tone = tone_data.tone, .offset = tone_data.offset };
}
