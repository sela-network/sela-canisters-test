import Nat "mo:base/Nat";

// Define the type for a Node
type Node = {
    id: Nat,
    isActive: Bool,
    lastCheckin: Nat, // Timestamp of the last check-in
    rewards: Nat
};

// Define the type for our principals (users/admins)
type Principal = Principal;

// Define the initial state
stable var nodes: [Node] = [];

// Register a new node
public shared ({caller}) func registerNode(id: Nat) : async Bool {
    let newNode = {
        id = id,
        isActive = true,
        lastCheckin = Time.now(),
        rewards = 0
    };
    nodes := Array.append<Node>(nodes, [newNode]);
    return true;
};

// Update node status
public shared ({caller}) func updateNodeStatus(id: Nat, isActive: Bool) : async Bool {
    // Find the node and update its status
    let nodeIndex = Array.findIndex(nodes, func (node) -> Bool {
        node.id == id
    });
    switch (nodeIndex) {
        case(null) { return false }; // Node not found
        case(?index) {
            nodes[index].isActive = isActive;
            nodes[index].lastCheckin = Time.now();
            return true;
        }
    };
};

// Get node status
public shared ({caller}) func getNodeStatus(id: Nat) : async ?Node {
    let nodeIndex = Array.findIndex(nodes, func (node) -> Bool {
        node.id == id
    });
    switch (nodeIndex) {
        case (null) { return null };
        case (?index) { return ?nodes[index] };
    }
};

// Get active nodes
public shared ({caller}) func getActiveNodes() : async [Node] {
    return Array.filter<Node>(nodes, func (node) -> Bool {
        node.isActive
    });
};

// Distribute rewards to nodes
public shared ({caller}) func distributeRewards() : async Bool {
    for (i in Iter.range(0, Array.size<Node>(nodes) - 1)) {
        if (nodes[i].isActive) {
            nodes[i].rewards += 1; // Example: award 1 $SELA token per distribution cycle
        }
    }
    return true;
};

// Claim rewards (representing ICP transactions)
public shared ({caller}) func claimRewards() : async Bool {
    let nodeIndex = Array.findIndex(nodes, func (node) -> Bool {
        node.id == Principal.toText(caller)
    });
    switch (nodeIndex) {
        case(null) { return false }; // Node not found
        case(?index) {
            // Example: initiate ICP transaction here
            let rewardsToClaim = nodes[index].rewards;
            nodes[index].rewards = 0; // reset rewards after claiming
            // Process the ICP transaction...
            // ...
            return true;
        }
    };
};

actor SelaNodeCanister {
    public shared ({caller}) func initialize() : async () {
        // Initialize any required state if necessary
    };
};