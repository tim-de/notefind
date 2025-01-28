const std = @import("std");
const print = std.debug.print;
const os = std.os;
const fmt = std.fmt;
const mem = std.mem;

const note = @import("note.zig");

pub fn main() !void {
    if (os.argv.len < 2) {
        print("Please supply a rate to convert.\n", .{});
        return;
    }
    const arglen = mem.len(os.argv[1]);
    const rate_arg = os.argv[1][0..arglen];
    if (fmt.parseFloat(f64, rate_arg)) |rate| {
        const note_data = note.tone_from_rate(rate);
        print("{d} per hour = {s}{d}, {s}{d:.0} cents\n", .{
            rate,
            note_data.tone.note.toString(),
            note_data.tone.octave,
            if (note_data.offset < 0) "" else "+",
            100 * note_data.offset,
        });
    } else |_| {
        print("Invalid input: '{s}'\n", .{os.argv[1]});
    }
}
