use anyhow::Context;

fn this_is_an_error() -> anyhow::Result<()> {
    Err(anyhow::anyhow!("Rust: This is an error"))
}

fn this_is_a_nested_yet_another_nested_call() -> anyhow::Result<()> {
    // ? operator expands to
    // let result = match this_is_an_error() {
    //     Ok(success_value) => success_value,
    //     Err(err) => return Err(err.context("this_is_a_nested_yet_another_nested_call()"))
    // };

    this_is_an_error().context("Rust: this_is_a_nested_yet_another_nested_call()")?;
    Ok(())
}

fn this_is_a_nested_another_nested_call() -> anyhow::Result<()> {
    this_is_a_nested_yet_another_nested_call()
        .context("Rust: this_is_a_nested_another_nested_call()")?;
    Ok(())
}

fn this_is_a_nested_call() -> anyhow::Result<()> {
    this_is_a_nested_another_nested_call().context("Rust: this_is_a_nested_call()")?;
    Ok(())
}

fn get_file_contents(path: &str) -> anyhow::Result<String> {
    std::fs::read_to_string(path).context(format!("Rust: Failed to read file {}", path))
}

pub fn check_error() {
    let content_result = get_file_contents("my_file.txt");
    match content_result {
        Ok(contents) => {
            println!("Rust: File contents: {}", contents);
        }
        Err(err) => {
            eprintln!("Rust: Error: {}", err);
        }
    }

    match this_is_a_nested_call() {
        Ok(_) => println!("Rust: Nested call succeeded"),
        Err(err) => eprintln!("Rust: Nested call failed: {:?}", err),
    }
}
