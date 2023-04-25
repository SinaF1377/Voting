const Vote = artifacts.require("Vote");

// Define the "Vote" contract tests using the Mocha testing framework
contract("Vote", (accounts) => {
  // Define a variable to hold the address of a voter
  let add = "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7";
  // Define a variable to hold the "Vote" contract instance
  let vote = null;

  before(async () => {
    vote = await Vote.deployed();
  });

  // Define a nested "describe" block to test the vote part of the smart contract
  describe("Test of vote part", async () => {
    it("Should add voter to list", async () => {
      // Call the "setVoter" function to add a voter to the list
      await vote.setVoter("sina", "image", add);
      // Retrieve the voter's information using the "getVoterByAllElement" function
      let myVoter = await vote.getVoterByAllElement(add);

      assert(myVoter[0] == 1);
      assert(myVoter[1] == "sina");
      assert(myVoter[2] == "image");
      assert(myVoter[3] == add);
      assert(myVoter[4] == true);
      assert(myVoter[5] == 3);
    });

    // Define an "it" block to test the "getAllAddressOfVoters" and "getVoterLength" functions of the smart contract
    it("Should all getter must be work", async () => {
      // Retrieve the list of all voters' addresses using the "getAllAddressOfVoters" function
      let _getAllAddressOfvoter = await vote.getAllAddressOfVoters();

      assert(_getAllAddressOfvoter[0] == add);
      // Retrieve the number of voters using the "getVoterLength" function
      let _numberOfVoters = await vote.getVoterLength();

      assert(_numberOfVoters == 1);
    });
  });

  describe("Test of Candidate Part", async () => {
    it("Should add Candidate to candidate list", async () => {
      // Call the "setCandidate" function to add a candidate to the list
      await vote.setCandidate("Sasan", 35, "image", add);
      // Retrieve the candidate's information using the "getCandidateByAllElement" function
      let candidate = await vote.getCandidateByAllElement(add);

      assert(candidate[0] == 1);
      assert(candidate[1] == "Sasan");
      assert(candidate[2] == 35);
      assert(candidate[3] == "image");
      assert(candidate[4] == add);
      assert(candidate[5] == 0);
    });

    it("Should Add getter must Work weel", async () => {
      // Retrieve the number of candidates using the "getCandidateLength" function
      let _numberOfCandidat = await vote.getCandidateLength();
      // Use the "assert" function to check that the retrieved information matches the expected values
      assert(_numberOfCandidat == 1);
      // Retrieve the list of all candidates' addresses using the "getAllCandidateAddress" function
      let _getAllCandidateAddress = await vote.getAllCandidateAddress();

      assert(_getAllCandidateAddress == add);
    });
  });

  describe("Test of Voting Function", async () => {
    it("should voting is work", async () => {
      await vote.setVoter("sina", "image", accounts[0]);
      await vote.setCandidate("Sasan", 35, "image", accounts[1]);
      await vote.votingMode(1);
      await vote.voting(accounts[1], { from: accounts[0] });

      let voterVoted = await vote.getVoterByAllElement(accounts[0]);
      let candidateVoted = await vote.getCandidateByAllElement(accounts[1]);

      assert(voterVoted[5] == 2); // The number of votes that can vote
      assert(candidateVoted[5] == 1); //The number of votes this candidate will get
    });
  });
});
