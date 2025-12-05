import { type Wallet } from "@aztec/aztec.js/wallet";
import { AztecAddress } from "@aztec/aztec.js/addresses";
import { createAztecNodeClient, waitForNode } from "@aztec/aztec.js/node";
import { type ContractFunctionInteractionCallIntent } from "@aztec/aztec.js/authorization";
import {
  registerInitialSandboxAccountsInWallet,
  TestWallet,
} from "@aztec/test-wallet/server";
import {
  Benchmark,
  type BenchmarkContext,
} from "@defi-wonderland/aztec-benchmark";

import { CounterContract } from "../src/artifacts/Counter.js";

// Extend the BenchmarkContext from the new package
interface CounterBenchmarkContext extends BenchmarkContext {
  wallet: Wallet;
  deployer: AztecAddress;
  accounts: AztecAddress[];
  counterContract: CounterContract;
}

// Use export default class extending Benchmark
export default class CounterContractBenchmark extends Benchmark {
  /**
   * Sets up the benchmark environment for the CounterContract.
   * Creates PXE client, gets accounts, and deploys the contract.
   */
  async setup(): Promise<CounterBenchmarkContext> {
    const { NODE_URL = "http://localhost:8080" } = process.env;
    const aztecNode = createAztecNodeClient(NODE_URL);
    await waitForNode(aztecNode);

    const wallet: TestWallet = await TestWallet.create(aztecNode);
    const accounts: AztecAddress[] =
      await registerInitialSandboxAccountsInWallet(wallet);

    const [deployer] = accounts;

    const counterContract = await CounterContract.deploy(wallet, deployer)
      .send({ from: deployer })
      .deployed();

    return { wallet, deployer, accounts, counterContract };
  }

  /**
   * Returns the list of CounterContract methods to be benchmarked.
   */
  getMethods(
    context: CounterBenchmarkContext,
  ): ContractFunctionInteractionCallIntent[] {
    const { counterContract, wallet, deployer } = context;

    const methods: ContractFunctionInteractionCallIntent[] = [
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_16_2(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_16_4(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_16_8(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_16_16(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_32_1(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_32_2(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_32_4(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_32_8(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_64_1(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_64_2(),
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_static_64_4(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_16_2(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_16_4(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_16_8(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_16_16(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_32_1(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_32_2(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_32_4(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_32_8(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_64_1(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_64_2(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_64_4(),
      },
      {
        caller: deployer,
        action: counterContract
          .withWallet(wallet)
          .methods.log_sequential_extra_work_32_8(),
      },
      /*
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_16_2()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_16_4()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_16_8()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_16_16()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_1()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_2()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_4()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_5()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_6()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_7()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_32_8()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_64_1()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_64_2()
      },
      {
        caller: deployer,
        action: counterContract.withWallet(wallet).methods.log_binary_64_4()
      },
      */
    ];

    return methods;
  }
}
