mod borrow_checker;
mod error_checking;
mod fearless_concurrency;

fn main() {
    borrow_checker::check_borrow();
    error_checking::check_error();
    fearless_concurrency::fearless_concurrency();

    println!("Rust: Hello, World!");
}
