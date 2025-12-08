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
    fn log_16(message: [Field; 16]) {
        context.emit_public_log(message)
    }

    #[external("public")]
    #[internal]
    fn log_32(message: [Field; 32]) {
        context.emit_public_log(message)
    }

    #[external("public")]
    #[internal]
    fn log_64(message: [Field; 64]) {
        context.emit_public_log(message)
    }

    #[external("private")]
    fn log_sequential_16(chunks: u8) -> Field {
        if chunks == 0 {
            0
        } else {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, 16);
            if chunks == 1 {
                hash
            } else {
                poseidon::poseidon2::Poseidon2::hash(
                    [
                        Counter::at(context.this_address()).log_sequential_16(chunks - 1).call(
                            &mut context,
                        ),
                        hash,
                    ],
                    2,
                )
            }
        }
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
                        Counter::at(context.this_address()).log_sequential_32(chunks - 1).call(
                            &mut context,
                        ),
                        hash,
                    ],
                    2,
                )
            }
        }
    }

    #[external("private")]
    fn log_sequential_64(chunks: u8) -> Field {
        if chunks == 0 {
            0
        } else {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 64] = unsafe { input::<64>() };
            Counter::at(context.this_address()).log_64(chunk).enqueue(&mut context);
            let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, 64);
            if chunks == 1 {
                hash
            } else {
                poseidon::poseidon2::Poseidon2::hash(
                    [
                        Counter::at(context.this_address()).log_sequential_64(chunks - 1).call(
                            &mut context,
                        ),
                        hash,
                    ],
                    2,
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
            let chunk: [Field; 32] = unsafe { input_extra_work::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            let hash: Field = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
            if chunks == 1 {
                hash
            } else {
                poseidon::poseidon2::Poseidon2::hash(
                    [
                        Counter::at(context.this_address())
                            .log_sequential_extra_work_32(chunks - 1)
                            .call(&mut context),
                        hash,
                    ],
                    2,
                )
            }
        }
    }

    #[external("private")]
    fn log_sequential_16_2() {
        let _ = Counter::at(context.this_address()).log_sequential_16(2).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_16_4() {
        let _ = Counter::at(context.this_address()).log_sequential_16(4).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_16_8() {
        let _ = Counter::at(context.this_address()).log_sequential_16(8).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_16_16() {
        let _ = Counter::at(context.this_address()).log_sequential_16(16).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_32_1() {
        let _ = Counter::at(context.this_address()).log_sequential_32(1).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_32_2() {
        let _ = Counter::at(context.this_address()).log_sequential_32(2).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_32_4() {
        let _ = Counter::at(context.this_address()).log_sequential_32(4).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_32_8() {
        let _ = Counter::at(context.this_address()).log_sequential_32(8).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_64_1() {
        let _ = Counter::at(context.this_address()).log_sequential_64(1).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_64_2() {
        let _ = Counter::at(context.this_address()).log_sequential_64(2).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_64_4() {
        let _ = Counter::at(context.this_address()).log_sequential_64(4).call(&mut context);
    }

    #[external("private")]
    fn log_sequential_extra_work_32_8() {
        let _ =
            Counter::at(context.this_address()).log_sequential_extra_work_32(8).call(&mut context);
    }

    #[external("private")]
    #[internal]
    fn log_balanced_binary_16(level: u8) -> Field {
        if level == 0 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            poseidon::poseidon2::Poseidon2::hash(chunk, 16)
        } else {
            poseidon::poseidon2::Poseidon2::hash(
                [
                    Counter::at(context.this_address()).log_balanced_binary_16(level - 1).call(
                        &mut context,
                    ),
                    Counter::at(context.this_address()).log_balanced_binary_16(level - 1).call(
                        &mut context,
                    ),
                ],
                2,
            )
        }
    }

    #[external("private")]
    #[internal]
    fn log_balanced_binary_32(level: u8) -> Field {
        if level == 0 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            poseidon::poseidon2::Poseidon2::hash(chunk, 32)
        } else {
            poseidon::poseidon2::Poseidon2::hash(
                [
                    Counter::at(context.this_address()).log_balanced_binary_32(level - 1).call(
                        &mut context,
                    ),
                    Counter::at(context.this_address()).log_balanced_binary_32(level - 1).call(
                        &mut context,
                    ),
                ],
                2,
            )
        }
    }

    #[external("private")]
    #[internal]
    fn log_balanced_binary_64(level: u8) -> Field {
        if level == 0 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 64] = unsafe { input::<64>() };
            Counter::at(context.this_address()).log_64(chunk).enqueue(&mut context);
            poseidon::poseidon2::Poseidon2::hash(chunk, 64)
        } else {
            poseidon::poseidon2::Poseidon2::hash(
                [
                    Counter::at(context.this_address()).log_balanced_binary_64(level - 1).call(
                        &mut context,
                    ),
                    Counter::at(context.this_address()).log_balanced_binary_64(level - 1).call(
                        &mut context,
                    ),
                ],
                2,
            )
        }
    }

    #[external("private")]
    fn log_binary_16(chunks: u8) -> Field {
        let mut hashes: [Field; 5] = [0; 5];
        let mut chunks = chunks;
        for i in 0..5 as u32 {
            if chunks % 2 == 1 {
                hashes[i] = Counter::at(context.this_address())
                    .log_balanced_binary_16(i as u8)
                    .call(&mut context)
            }
            chunks /= 2;
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 8)
    }

    #[external("private")]
    fn log_binary_32(chunks: u8) -> Field {
        let mut hashes: [Field; 5] = [0; 5];
        let mut chunks = chunks;
        for i in 0..5 as u32 {
            if chunks % 2 == 1 {
                hashes[i] = Counter::at(context.this_address())
                    .log_balanced_binary_32(i as u8)
                    .call(&mut context)
            }
            chunks /= 2;
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 8)
    }

    #[external("private")]
    fn log_binary_64(chunks: u8) -> Field {
        let mut hashes: [Field; 5] = [0; 5];
        let mut chunks = chunks;
        for i in 0..5 as u32 {
            if chunks % 2 == 1 {
                hashes[i] = Counter::at(context.this_address())
                    .log_balanced_binary_64(i as u8)
                    .call(&mut context)
            }
            chunks /= 2;
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 8)
    }

    #[external("private")]
    fn log_binary_16_2() {
        let _ = Counter::at(context.this_address()).log_binary_16(2).call(&mut context);
    }

    #[external("private")]
    fn log_binary_16_4() {
        let _ = Counter::at(context.this_address()).log_binary_16(4).call(&mut context);
    }

    #[external("private")]
    fn log_binary_16_8() {
        let _ = Counter::at(context.this_address()).log_binary_16(8).call(&mut context);
    }

    #[external("private")]
    fn log_binary_16_16() {
        let _ = Counter::at(context.this_address()).log_binary_16(16).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_1() {
        let _ = Counter::at(context.this_address()).log_binary_32(1).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_2() {
        let _ = Counter::at(context.this_address()).log_binary_32(2).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_4() {
        let _ = Counter::at(context.this_address()).log_binary_32(4).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_5() {
        let _ = Counter::at(context.this_address()).log_binary_32(5).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_6() {
        let _ = Counter::at(context.this_address()).log_binary_32(6).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_7() {
        let _ = Counter::at(context.this_address()).log_binary_32(7).call(&mut context);
    }

    #[external("private")]
    fn log_binary_32_8() {
        let _ = Counter::at(context.this_address()).log_binary_32(8).call(&mut context);
    }

    #[external("private")]
    fn log_binary_64_1() {
        let _ = Counter::at(context.this_address()).log_binary_64(1).call(&mut context);
    }

    #[external("private")]
    fn log_binary_64_2() {
        let _ = Counter::at(context.this_address()).log_binary_64(2).call(&mut context);
    }

    #[external("private")]
    fn log_binary_64_4() {
        let _ = Counter::at(context.this_address()).log_binary_64(4).call(&mut context);
    }

    #[external("private")]
    fn log_static_16_2() -> Field {
        let mut hashes: [Field; 2] = [0; 2];
        for i in 0..2 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 16);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 2)
    }

    #[external("private")]
    fn log_static_16_4() -> Field {
        let mut hashes: [Field; 4] = [0; 4];
        for i in 0..4 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 16);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 4)
    }

    #[external("private")]
    fn log_static_16_8() -> Field {
        let mut hashes: [Field; 8] = [0; 8];
        for i in 0..8 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 16);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 8)
    }

    #[external("private")]
    fn log_static_16_16() -> Field {
        let mut hashes: [Field; 16] = [0; 16];
        for i in 0..16 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 16] = unsafe { input::<16>() };
            Counter::at(context.this_address()).log_16(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 16);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 16)
    }

    #[external("private")]
    fn log_static_32_1() -> Field {
        let mut hashes: [Field; 1] = [0; 1];
        for i in 0..1 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 1)
    }

    #[external("private")]
    fn log_static_32_2() -> Field {
        let mut hashes: [Field; 2] = [0; 2];
        for i in 0..2 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 2)
    }

    #[external("private")]
    fn log_static_32_4() -> Field {
        let mut hashes: [Field; 4] = [0; 4];
        for i in 0..4 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 4)
    }

    #[external("private")]
    fn log_static_32_8() -> Field {
        let mut hashes: [Field; 8] = [0; 8];
        for i in 0..8 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 32] = unsafe { input::<32>() };
            Counter::at(context.this_address()).log_32(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 32);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 8)
    }

    #[external("private")]
    fn log_static_64_1() -> Field {
        let mut hashes: [Field; 1] = [0; 1];
        for i in 0..1 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 64] = unsafe { input::<64>() };
            Counter::at(context.this_address()).log_64(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 64);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 1)
    }

    #[external("private")]
    fn log_static_64_2() -> Field {
        let mut hashes: [Field; 2] = [0; 2];
        for i in 0..2 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 64] = unsafe { input::<64>() };
            Counter::at(context.this_address()).log_64(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 64);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 2)
    }

    #[external("private")]
    fn log_static_64_4() -> Field {
        let mut hashes: [Field; 4] = [0; 4];
        for i in 0..4 as u32 {
            // Safety: this is indeed arbitrary
            let chunk: [Field; 64] = unsafe { input::<64>() };
            Counter::at(context.this_address()).log_64(chunk).enqueue(&mut context);
            hashes[i] = poseidon::poseidon2::Poseidon2::hash(chunk, 64);
        }
        poseidon::poseidon2::Poseidon2::hash(hashes, 4)
    }
}
