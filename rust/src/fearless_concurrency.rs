pub fn fearless_concurrency() {
    // Create a mutex that holds a u32 value and initialize it with 10
    let mutex = std::sync::Mutex::<u32>::new(10);

    // pass ownership of the mutex to the async reference counter
    let arc = std::sync::Arc::new(mutex);

    let arc0 = arc.clone();
    let handled0 = std::thread::spawn(move || match arc0.lock() {
        Ok(mut inner) => {
            println!("Rust: Initial value: {}", *inner);
            *inner += 5;
            println!("Rust: New value: {}", *inner);
        }
        Err(e) => {
            eprintln!("Rust: Error: {}", e);
        }
    });

    let arc1 = arc.clone();
    let handled1 = std::thread::spawn(move || match arc1.lock() {
        Ok(mut inner) => {
            println!("Rust: Initial value: {}", *inner);
            *inner += 5;
            println!("Rust: New value: {}", *inner);
        }
        Err(e) => {
            eprintln!("Rust: Error: {}", e);
        }
    });

    match (handled0.join(), handled1.join()) {
        (Ok(_), Ok(_)) => println!("Rust: Both threads completed successfully"),
        (Err(e0), Err(e1)) => eprintln!("Rust: Errors: {:?} and {:?}", e0, e1),
        (Err(e), _) | (_, Err(e)) => eprintln!("Rust: Error: {:?}", e),
    }
}
