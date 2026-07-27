fn main() {
    let a: i32 = 42;
    let b = &a as *const i32 as i32;
    let c = a + b;
    println!("Data is here {} and plus magic {c}", b);
}