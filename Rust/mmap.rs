use std::arch::asm;

fn mmap_i64() -> *mut i64 {
    let ptr: *mut i64;
    unsafe {
        asm!(
            "mov rax, 9",
            "xor rdi, rdi",
            "mov rsi, 8",
            "mov rdx, 3",
            "mov r10, 34",
            "mov r8, -1",
            "xor r9, r9",
            "syscall",
            out("rax") ptr,
            out("rcx") _, out("r11") _,
            out("rdi") _, out("rsi") _,
            out("rdx") _, out("r10") _,
            out("r8")  _, out("r9")  _,
        );
    }
    ptr
}

fn main() {
    let x: &mut i64 = unsafe { mmap_i64().as_mut().unwrap() };

    *x = 42;
    println!("x = {}", x);

    *x += 100;
    println!("x = {}", x);
}