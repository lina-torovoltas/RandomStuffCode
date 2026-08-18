const std = @import("std");



pub fn main() void {
    const msg = "Hello, World!\n";

    asm volatile (
        \\syscall
        :
        : [sys_num] "{rax}" (1),
          [fd] "{rdi}" (1),
          [msg] "{rsi}" (msg.ptr),
          [len_msg] "{rdx}" (msg.len),
        : .{
            .rcx = true,
            .r11 = true,
          }
    );
}
