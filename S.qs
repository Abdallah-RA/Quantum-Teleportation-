namespace RA {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation QuantumMain() : Unit {
        // Define the message.
        let message = [RandomInt(2), RandomInt(2)];
        Message($"Message is {message}");
        using ( (AliceQ, SharedQ, BobQ) = (Qubit(), Qubit(), Qubit()) ) {
            // Prepare the state of Alice's qubit in a                 superposition
            H(AliceQ);

            // Collapse the state of Alice's qubit                     randomly and report
            let AliceInit = M(AliceQ);
            Message($"Initial Alice state: {AliceInit}");

            // Prepare the Bell state between shared                     qubit and Bob's qubit.
            PrepareBell(SharedQ, BobQ);

            // Alice generates two classical bits from                  the two qubits
            Decode(AliceQ, SharedQ);
            let decoded = ExtractMessage(AliceQ,SharedQ);
            Message($"Alice generate: {decoded}");
            // Send the classical message to Bob who                    encodes it in his qubits
            Encode(BobQ, decoded);

            // Bob's qubit is now in the same state that               Alice's was to start.
            let BobFinal = M(BobQ);
            Message($"Final Bob state: {BobFinal}");

            // Return all qubits to the |0> state before              finishing with them.
            Reset(AliceQ); Reset(SharedQ); Reset(BobQ);
        }
           
    }
    
    operation Encode(AliceQ : Qubit, message : Int[]) : Unit {
        // Encode the message into Alice's qubit
        if (message[0] == 0 and message[1] == 0) {
            // No operation.
        } elif (message[0] == 1 and message[1] == 0) {
            X(AliceQ);
        } elif (message[0] == 0 and message[1] == 1) {
            Z(AliceQ);
        } elif (message[0] == 1 and message[1] == 1) {
            Z(AliceQ);
            X(AliceQ);
        }
    }
    operation Decode(AliceQ : Qubit, BobQ : Qubit) : Unit {
        // Decode the message from the two qubits.
        CNOT(AliceQ, BobQ);
        H(AliceQ);
    }
    operation PrepareBell(AliceQ : Qubit, BobQ : Qubit) : Unit {
        H(AliceQ);
        CNOT(AliceQ, BobQ);
    }
operation ExtractMessage(AliceQ : Qubit, SharedQ : Qubit) : Int[] {
    let result1 = M(AliceQ);
    let result2 = M(SharedQ);
   return [ResultArrayAsInt([result1]), ResultArrayAsInt([result2])];
}
}