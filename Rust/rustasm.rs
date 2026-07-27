use std::arch::asm;

fn main() {
    const MSG: &str = "Hello, World!\n";

    unsafe {
        asm!(
            "mov rax, 1",
            "mov rdi, 1",
            "mov rsi, {msg}",
            "mov rdx, {len_msg}",
            "syscall",
            msg = in(reg) MSG.as_ptr(),
            len_msg = const MSG.len(),
            out("rax") _, out("rcx") _, out("r11") _,
        );
    }
}
