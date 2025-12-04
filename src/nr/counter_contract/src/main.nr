use aztec::macros::aztec;
// pub mod test;

#[aztec]
pub contract Counter {
    // aztec library imports
    use aztec::{
        context::PrivateContext,
        macros::{functions::{external, initializer}, storage::storage},
        protocol_types::address::AztecAddress,
        state_vars::PublicImmutable,
    };

    // @param owner The address of the owner
    // @param counter A numerical value
    #[storage]
    struct Storage<Context> {
        owner: PublicImmutable<AztecAddress, Context>,
    }

    /// @dev Initialize the contract
    /// @param owner The address of the owner
    #[external("public")]
    #[initializer]
    fn constructor(owner: AztecAddress) {
        storage.owner.initialize(owner);
    }

    /// @dev Retrieves the owner of the contract
    /// @return The owner of the contract
    #[external("public")]
    fn get_owner() -> AztecAddress {
        storage.owner.read()
    }

    /*
    #[contract_library_method]
    #[oracle(input)]
    unconstrained fn input_oracle<let N: u32>() -> [Field; N] { }

    #[contract_library_method]
    unconstrained fn input<let N: u32>() -> [Field; N] {
        input_oracle()
    }
    */

    #[contract_library_method]
    unconstrained fn input<let N: u32>() -> [Field; N] {
        let mut result: [Field; N] = [0; N];
        for i in 0..N {
            result[i] = aztec::oracle::random::random();
        }
        result
    }

    /*
        let mut result: [Field; N] = [0; N];
        for i in 0..N {
            // Safety: we don't care what this is
            result[i] = aztec::oracle::random::random();
        }
        result
    }
    */

    #[contract_library_method]
    fn log_sequential<let N: u32>(context: &mut PrivateContext, remaining_chunks: u8) -> Field {
        // Safety: this is indeed arbitrary
        let chunk: [Field; N] = unsafe { input::<N>() };
        let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, N);
        if remaining_chunks == 0 {
            hash
        } else {
            poseidon::poseidon2::Poseidon2::hash(
                [
                    log_sequential::<N>(context, remaining_chunks - 1),
                    hash
                ],
                2
            )
        }
    }

    #[external("private")]
    fn log_sequential_128(remaining_chunks: u8) -> Field {
        log_sequential::<128>(&mut context, remaining_chunks)
    }

    /////////////////////////////////////////////////

    /*
    /// @dev Increments the counter
    #[external("private")]
    fn increment() {
        Counter::at(context.this_address()).increment_internal().enqueue(&mut context);
    }

    /// @dev Retrieves the counter value
    /// @return The current counter value
    #[external("public")]
    #[view]
    fn get_counter() -> u128 {
        storage.counter.read()
    }

    /// @dev Increments the counter
    #[external("public")]
    #[internal]
    fn increment_internal() {
        let current_value = storage.counter.read();
        storage.counter.write(current_value + 1);
    }
    */
}
