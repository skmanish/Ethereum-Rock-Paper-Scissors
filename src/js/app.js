App = {
  web3Provider: null,
  contracts: {},

  init: function() {

    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('RPS.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var RPSArtifact = data;
      App.contracts.RPS = TruffleContract(RPSArtifact);

      // Set the provider for our contract
      App.contracts.RPS.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.resetContract();
    });

    return App.bindEvents();
  },

  resetContract: function(){
    var rpsInstance;
    App.contracts.RPS.deployed().then(function(instance) {
      rpsInstance = instance;
      return rpsInstance.cleanup.call();
    }).then(function(){
      console.log("Successfully reset the contract to begin state");
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  getUser : function(id){
    var rpsInstance;
    App.contracts.RPS.deployed().then(function(instance) {
      rpsInstance = instance;
      if(id==1)
        return rpsInstance.getUser1.call();
      else
        return rpsInstance.getUser2.call();
    }).then(function(address){
      if(id==1)
        document.getElementById("user1").innerHTML = address;
      else
        document.getElementById("user2").innerHTML = address;
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  registerUser : function(){
    var rpsInstance;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];
      console.log(account)
      App.contracts.RPS.deployed().then(function(instance) {
        rpsInstance = instance;
        return rpsInstance.register({from: account})
      }).then(function(){
        console.log("Successfully Registered User1");
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
