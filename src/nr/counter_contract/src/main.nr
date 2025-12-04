use aztec::macros::aztec;
// pub mod test;

#[aztec]
pub contract Counter {
    // aztec library imports
    use aztec::{
        macros::{functions::{external, initializer, internal}, storage::storage},
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

    #[contract_library_method]
    unconstrained fn input_extra_work<let N: u32>() -> [Field; N] {
        let mut result: [Field; N] = [0; N];
        for i in 0..N {
            result[i] += aztec::oracle::random::random();
            result[i] += aztec::oracle::random::random();
        }
        result
    }

    #[external("public")]
    #[internal]
    fn log_32(message: [Field; 32]) {
        context.emit_public_log(message)
    }

    #[external("private")]
    fn log_sequential_32(chunks: u8) -> Field {
        if chunks == 0 {
            0
        } else {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
            if chunks == 1 {
                hash
            } else {
                poseidon::poseidon2::Poseidon2::hash(
                    [
                        Counter::at(context.this_address()).log_sequential_32(chunks - 1).call(&mut context),
                        hash
                    ],
                    2
                )
            }
        }
    }

    #[external("private")]
    fn log_sequential_extra_work_32(chunks: u8) -> Field {
        if chunks == 0 {
            0
        } else {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
            if chunks == 1 {
                hash
            } else {
                poseidon::poseidon2::Poseidon2::hash(
                    [
                        Counter::at(context.this_address()).log_sequential_32(chunks - 1).call(&mut context),
                        hash
                    ],
                    2
                )
            }
        }
    }

    #[external("private")]
    fn log_sequential_32_8() {
        let _ = Counter::at(context.this_address()).log_sequential_32(8).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_extra_work_32_8() {
        let _ = Counter::at(context.this_address()).log_sequential_extra_work_32(8).call(&mut context);
    }
}
