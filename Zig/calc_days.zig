// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;



fn ConvertDateToDays(day: u5, month: u4, year: u11) i64 {
    const a: i64 = @divFloor(14 - @as(i64, month), 12);
    const y: i64 = @as(i64, year) + 4800 - a;
    const m: i64 = @as(i64, month) + 12 * a - 3;

    const result: i64 = @as(i64, day)
        + @divFloor(153 * m + 2, 5)
        + 365 * y
        + @divFloor(y, 4)
        - @divFloor(y, 100)
        + @divFloor(y, 400)
        - 32045;

    return result;
}


pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [16]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buf);

    print("Enter first date (dd-mm-yyyy): ", .{});

    const first_date = try input.interface.takeDelimiter('\n') orelse return;

    if (first_date.len == 0) {
        print("You had to enter date!!!\n", .{});
        return;
    }

    var first_date_parts = std.mem.splitScalar(u8, first_date, '-');
    
    const first_date_days_str = first_date_parts.next() orelse return error.NotEnough;
    const first_date_months_str = first_date_parts.next() orelse return error.NotEnough;
    const first_date_years_str = first_date_parts.next() orelse return error.NotEnough;

    const first_date_days = try std.fmt.parseInt(u5, first_date_days_str, 10);
    const first_date_months = try std.fmt.parseInt(u4, first_date_months_str, 10);
    const first_date_years = try std.fmt.parseInt(u11, first_date_years_str, 10);

    const days_of_first_date: i64 = ConvertDateToDays(first_date_days, first_date_months, first_date_years);

    print("Enter second date (dd-mm-yyyy): ", .{});
    
    const second_date = try input.interface.takeDelimiter('\n') orelse return;
    
    if (second_date.len == 0) {
        print("You had to enter date!!!\n", .{});
        return;
    }
    
    var second_date_parts = std.mem.splitScalar(u8, second_date, '-');
        
    const second_date_days_str = second_date_parts.next() orelse return error.NotEnough;
    const second_date_months_str = second_date_parts.next() orelse return error.NotEnough;
    const second_date_years_str = second_date_parts.next() orelse return error.NotEnough;
    
    const second_date_days = try std.fmt.parseInt(u5, second_date_days_str, 10);
    const second_date_months = try std.fmt.parseInt(u4, second_date_months_str, 10);
    const second_date_years = try std.fmt.parseInt(u11, second_date_years_str, 10);
    
    const days_of_second_date: i64 = ConvertDateToDays(second_date_days, second_date_months, second_date_years);

    const difference_between_dates_in_days: i64 = days_of_second_date - days_of_first_date;

    print("The difference in days between the dates is: {}\n", .{difference_between_dates_in_days});
}
