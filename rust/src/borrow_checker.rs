pub fn borrow(value: &i32) -> &i32 {
    value
}

// lifetime 'a must outlive 'b
pub fn borrow_explicit_lifetimes<'b, 'a: 'b>(value: &'a mut i32) -> &'b mut i32 {
    value
}

pub fn check_borrow() {
    // A borrow in rust is like a reference in C++
    // The borrow checker keeps track of ownership and lifetimes
    let value = 5;

    // compiler guarantees value outlives borrowed_value
    {
        let borrowed_value = borrow(&value);
        println!("Rust: borrowed_value: {}", borrowed_value);
    }

    // can redeclare variables, previous value is dropped
    let mut value = value;
    // can't mutably borrow when already borrowed immutably
    let borrowed_mut = borrow_explicit_lifetimes(&mut value);
    *borrowed_mut = 10;
    println!("Rust: borrowed_mut: {}", borrowed_mut);
}
