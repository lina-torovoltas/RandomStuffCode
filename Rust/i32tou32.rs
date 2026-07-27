fn add(x: i32, y: i32) -> u32 {
    return x as u32 + y as u32;
}

fn main() {
    println!("{}", add(-42, 13));
}