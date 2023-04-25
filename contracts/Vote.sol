// SPDX-License-Identifier: MIT
pragma solidity >=0.8 <0.9.0;

// Import the Counters library
import "./Counters.sol";
import "./FindBigestNumberOfArray.sol";

// Define the Vote contract
contract Vote {
    FindBigestNumberOfArray findBigestNumberOfArray; // by this contract We can sort our array ;

    // Use the Counters library for voter and candidate IDs
    using Counters for Counters.Counter;
    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    // Define contract variables
    address public owner; // Address of contract owner
    address[] public votersAddress; // Array of registered voter addresses
    address[] public candidatesAddress; // Array of candidate addresses

    // Define mappings for voters and candidates
    mapping(address => Voter) public voters;
    mapping(address => Candidate) public candidates;

    // Define the constructor function
    constructor() {
        owner = msg.sender; // Set the contract owner to the address that deploys the contract
    }

    // Define the state of the vote using an enum
    enum stateOfVote {
        JUSTALLOWTOREGISTER, // 0
        JUSTALLOWTOVOTE, // 1
        JUSTRESULT // 2
    }

    stateOfVote stateOfVoted; // Variable to store the current state of the vote

    // Define the onlyOwner modifier to restrict access to the contract owner
    modifier onlyOwner() {
        require(owner == msg.sender, "You are not Owner");
        _;
    }

    // Define the onlyJUSTALLOWTOREGISTER modifier to restrict access during the registration phase
    modifier onlyJUSTALLOWTOREGISTER() {
        require(
            stateOfVoted == stateOfVote.JUSTALLOWTOREGISTER,
            "We are in the registration phase!!"
        );
        _;
    }

    // Define the onlyJUSTALLOWTOVOTE modifier to restrict access during the voting phase
    modifier onlyJUSTALLOWTOVOTE() {
        require(
            stateOfVoted == stateOfVote.JUSTALLOWTOVOTE,
            "We are in the voting phase!!"
        );
        _;
    }

    // Define the onlyJUSTRESULT modifier to restrict access during the results phase
    modifier onlyJUSTRESULT() {
        require(
            stateOfVoted == stateOfVote.JUSTRESULT,
            "We are in the process of announcing the voting results!!!"
        );
        _;
    }

    function votingMode(uint256 _index) public {
        require(_index <= 2 && _index >= 0, "Your input is incorent");
        if (_index == 0) {
            stateOfVoted = stateOfVote.JUSTALLOWTOREGISTER;
        }
        if (_index == 1) {
            stateOfVoted = stateOfVote.JUSTALLOWTOVOTE;
        } else if (_index == 2) {
            stateOfVoted = stateOfVote.JUSTRESULT;
        }
    }

    // Define the Voter struct
    struct Voter {
        uint256 voterId; // Unique ID for the voter
        string name; // Name of the voter
        string image; // Image of the voter
        address _address; // Ethereum address of the voter
        bool allowed; // Whether the voter is allowed to vote
        uint256 numVote; // Number of votes the voter is allowed to cast
    }

    // Define the VoterCreated event, which is emitted when a new voter is registered
    event VoterCreated(
        uint256 voterId,
        string name,
        string image,
        address _address,
        bool allowed,
        uint256 numVote
    );

    // Define the setVoter function, which is used to register a new voter
    function setVoter(
        string memory _name,
        string memory _image,
        address _add
    ) public onlyOwner onlyJUSTALLOWTOREGISTER {
        Voter memory voter; // Create a new Voter struct
        _voterId.increment(); // Increment the voter ID counter
        voter.voterId = _voterId.current(); // Set the voter ID
        voter.name = _name; // Set the voter name
        voter.image = _image; // Set the voter image
        voter._address = _add; // Set the voter Ethereum address
        voter.allowed = true; // Allow the voter to cast votes
        voter.numVote = 1; // Set the number of votes the voter is allowed to cast

        voters[_add] = voter; // Add the voter to the voters mapping
        votersAddress.push(_add); // Add the voter's Ethereum address to the votersAddress array

        emit VoterCreated(
            voter.voterId,
            voter.name,
            voter.image,
            voter._address,
            true,
            voter.numVote
        ); // Emit the VoterCreated event
    }

    // Define the getAllAddressOfVoters function, which returns an array of all registered voter Ethereum addresses
    function getAllAddressOfVoters() public view returns (address[] memory) {
        return votersAddress;
    }

    // Define the getVoter function, which returns the Voter struct for a given Ethereum address
    function getVoter(address _address) public view returns (Voter memory) {
        return voters[_address];
    }

    // Define the getVoterByAllElement function, which returns all elements of the Voter struct for a given Ethereum address
    function getVoterByAllElement(
        address _address
    )
        public
        view
        returns (uint256, string memory, string memory, address, bool, uint256)
    {
        return (
            voters[_address].voterId,
            voters[_address].name,
            voters[_address].image,
            voters[_address]._address,
            voters[_address].allowed,
            voters[_address].numVote
        );
    }

    // Define the getVoterLength function, which returns the number of registered voters
    function getVoterLength() public view returns (uint256) {
        return votersAddress.length;
    }

    // Define the Candidate struct
    struct Candidate {
        uint256 candidateId; // Unique ID for the candidate
        string name; // Name of the candidate
        uint256 age; // Age of the candidate
        string image; // Image of the candidate
        address _address; // Ethereum address of the candidate
        uint256 voteCount; // Number of votes received by the candidate
    }

    // Define the CandidateCreated event, which is emitted when a new candidate is registered
    event CandidateCreated(
        uint256 _candidateId,
        string name,
        uint256 age,
        string image,
        address _address,
        uint256 voteCount
    );

    // Define the setCandidate function, which is used to register a new candidate
    function setCandidate(
        string memory _name,
        uint256 _age,
        string memory _image,
        address _add
    ) public onlyOwner onlyJUSTALLOWTOREGISTER {
        Candidate memory candidate; // Create a new Candidate struct
        _candidateId.increment(); // Increment the candidate ID counter
        candidate.candidateId = _candidateId.current(); // Set the candidate ID
        candidate.name = _name; // Set the candidate name
        candidate.age = _age; // Set the candidate age
        candidate.image = _image; // Set the candidate image
        candidate._address = _add; // Set the candidate Ethereum address
        candidate.voteCount = 0; // Initialize the candidate's vote count to zero

        candidates[_add] = candidate; // Add the candidate to the candidates mapping

        emit CandidateCreated(
            candidate.candidateId,
            candidate.name,
            candidate.age,
            candidate.image,
            candidate._address,
            candidate.voteCount
        ); // Emit the CandidateCreated event

        candidatesAddress.push(_add); // Add the candidate's Ethereum address to the candidatesAddress array
    }

    // Define the getCandidateLength function, which returns the number of registered candidates
    function getCandidateLength() public view returns (uint256) {
        return candidatesAddress.length;
    }

    // Define the getAllCandidateAddress function, which returns an array of all registered candidate Ethereum addresses
    function getAllCandidateAddress() public view returns (address[] memory) {
        return candidatesAddress;
    }

    // array of name and address and number of vote number of every candidate.

    // Define the getCandidateByAllElement function, which returns all elements of the Candidate struct for a given Ethereum address
    function getCandidateByAllElement(
        address _address
    )
        public
        view
        returns (
            uint256,
            string memory,
            uint256,
            string memory,
            address,
            uint256
        )
    {
        return (
            candidates[_address].candidateId,
            candidates[_address].name,
            candidates[_address].age,
            candidates[_address].image,
            candidates[_address]._address,
            candidates[_address].voteCount
        );
    }

    // Define the voting function, which allows a voter to cast a vote for a given candidate
    function voting(address _address) public onlyJUSTALLOWTOVOTE {
        require(
            voters[msg.sender].allowed == true,
            "You are not allowed to vote"
        ); // Check if the voter is allowed to vote
        require(
            voters[msg.sender].numVote != 0,
            "You have voted 3 times and you cannot vote more than this"
        ); // Check if the voter has any remaining votes

        // candidates[_address].voteCount = candidates[_address].voteCount + 1; // Increment the vote count for the given candidate
        candidates[_address].voteCount += 1; // Increment the vote count for the given candidate
        voters[msg.sender].numVote = voters[msg.sender].numVote - 1; // Decrement the number of remaining votes for the voter

        if (voters[msg.sender].numVote == 0) {
            voters[msg.sender].allowed = false; // If the voter has no remaining votes, disallow them from voting again
        }
    }

    //***************************  RESULT OF VOTING  *********************** */

    uint256[] candidatesNumberVoted;

    function resultOFVoting()
        public
        onlyJUSTRESULT
        returns (string memory, address, uint256)
    {
        for (uint256 i = 0; i <= candidatesAddress.length; i++) {
            candidatesNumberVoted.push(
                candidates[candidatesAddress[i]].voteCount
            ); // in this part all of number of voted is saved
        }

        (uint256 maxValue, uint256 indexValue) = findBigestNumberOfArray
            .getMaxValueAndIndex(candidatesNumberVoted);

        return (
            candidates[candidatesAddress[indexValue]].name,
            candidates[candidatesAddress[indexValue]]._address,
            maxValue
        );
    }
}
