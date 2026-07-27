use rand::RngExt;
use std::thread::sleep;
use std::time::Duration;

fn main() {
    let mut rng = rand::rng();
    let mut progress: u64 = 0;

    while progress < 100 {
        let max = (progress + 20).min(100);
        progress = rng.random_range(progress+1..=max);

        println!("Pentagon hack progress: {}%", progress);

        sleep(Duration::from_secs(1));
    }

    if rng.random_range(1..=30) > 20 {
        println!("Pentagon hack: Completed successfully.");
        
    } else {
        println!("Pentagon hack: Failed.");
    }
}