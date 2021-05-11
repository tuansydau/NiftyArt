/* Main Object to manage Contract interactions */
var App = {

  contracts: {},
  CryptoDoggiesAddress: '0xAedEa36E917b7b6EC124b55E86cc42B13D7Cf113',

  async init() {
    return await App.initWeb3();
	},

  async initWeb3() {
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try{
        await window.ethereum.enable();
        console.log("Metamask connected");
      } catch (error) {
        console.error("Metamask unavailable");
      }
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);
    return App.initContract();
  },

  // initWeb3: async function() {
  //   //----
  //   // Modern dapp browsers...
  //   if (window.ethereum) {
  //     App.web3Provider = window.ethereum;
  //     try {
  //       // Request account access
  //       await window.ethereum.enable();
  //     } catch (error) {
  //       // User denied account access...
  //       console.error("User denied account access")
  //     }
  //   },

  initContract() {
    $.getJSON('CryptoDoggies.json', (data) => {
      const CryptoDoggiesArtifact = data;
      App.contracts.CryptoDoggies = TruffleContract(CryptoDoggiesArtifact);
      App.contracts.CryptoDoggies.setProvider(App.web3Provider);
      return App.loadDoggies();
    });
    return App.bindEvents();
  }, 

  loadDoggies() {
    web3.eth.getAccounts(function(err, accounts){
      if (err != null) {
        console.error("An error occurred: " + err);
      } else if (accounts.length == 0) {
        console.log("User is not logged into MetaMask");
      } else {
        $('#card-row').children().remove();
      }
    });

    var address = web3.eth.defaultAccount;
    let contractInstance = App.contracts.CryptoDoggies.at(App.CryptoDoggiesAddress);
    return totalSupply = contractInstance.totalSupply().then((supply) => {
      for (var i = 0; i < supply; i++){
        App.getDoggyDetails(i, address);
      }
    }).catch((err) => {
      console.log(err.message);
    });
  }, 

  getDoggyDetails(doggyId, localAddress) {
    let contractInstance = App.contracts.CryptoDoggies.at(App.CryptoDoggiesAddress);
    return contractInstance.getToken(doggyId).then((doggy) => {
      var doggyJson = {
        'doggyId': doggyId,
        'doggyName': doggy[0], //String _tokenName, first field in CryptoDoggies.sol
        'doggyDna': doggy[1],
        'doggyPrice': web3.fromWei(doggy[2]).toNumber(),
        'doggyNextPrice': web3.fromWei(doggy[3]).toNumber(),
        'ownerAddress': doggy[4]
      };
      if (doggyJson.ownerAddress !== localAddress){
        loadDoggy(
          doggyJson.doggyId,
          doggyJson.doggyName,
          doggyJson.doggyDna,
          doggyJson.doggyPrice,
          doggyJson.doggyNextPrice,
          doggyJson.ownerAddress,
          false
        );
      } else {
        loadDoggy(
          doggyJson.doggyId,
          doggyJson.doggyName,
          doggyJson.doggyDna,
          doggyJson.doggyPrice,
          doggyJson.doggyNextPrice,
          doggyJson.ownerAddress,
          true
        );
      }
    }).catch((err) => {
      console.log(err.message);
    });
  },

  handlePurchase(event) {
    event.preventDefault();

    var doggyId = parseInt($(event.target.elements).closest('.btn-buy').data('id'));

    web3.eth.getAccounts((error, accounts) => {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];

      let contractInstance = App.contracts.CryptoDoggies.at(App.CryptoDoggiesAddress);
      contractInstance.priceOf(doggyId).then((price) => {
        return contractInstance.purchase(doggyId, {
          from: account,
          value: price,
        }).then(result => App.loadDoggies()).catch((err) => {
          console.log(err.message);
        });
      });
    });
  },

  bindEvents() {
    $(document).on('submit', 'form.doggy-purchase', App.handlePurchase);
  },

};

/* Generates a Doggy image based on Doggy DNA */
function generateDoggyImage(doggyId, size, canvas){
  size = size || 10;
  var data = doggyidparser(doggyId);
  var canvas = document.getElementById(canvas);
  canvas.width = size * data.length;
  canvas.height = size * data[1].length;
  var ctx = canvas.getContext("2d");

  for(var i = 0; i < data.length; i++){
      for(var j = 0; j < data[i].length; j++){
          var color = data[i][j];
          if(color){
          ctx.fillStyle = color;
          ctx.fillRect(i * size, j * size, size, size);
          }
      }
  }
  return canvas.toDataURL();
}

function loadDoggy(doggyId, doggyName, doggyDna, doggyPrice, doggyNextPrice, ownerAddress, locallyOwned){
  var cardRow = $('#card-row');
  var cardTemplate = $('#card-template');

  if (locallyOwned) {
    cardTemplate.find('btn-buy').attr('disabled', true);
  } else{
    cardTemplate.find('btn-buy').removeAttr('disabled');
  }

  cardTemplate.find('.doggy-name').text(doggyName);
  cardTemplate.find('.doggy-canvas').attr('id', "doggy-canvas-" + doggyId);
  cardTemplate.find('.doggy-dna').text(doggyDna);
  cardTemplate.find('.doggy-owner').text(ownerAddress);
  cardTemplate.find('.doggy-owner').attr("href", "https://etherscan.io/address/" + ownerAddress);
  cardTemplate.find('.btn-buy').attr('data-id', doggyId);
  cardTemplate.find('.doggy-price').text(parseFloat(doggyPrice).toFixed(4));
  cardTemplate.find('.doggy-next-price').text(parseFloat(doggyNextPrice).toFixed(4));

  cardRow.append(cardTemplate.html());
  generateDoggyImage(doggyDna, 3, "doggy-canvas-" + doggyId);
}

/* Called When Document has loaded */
jQuery(document).ready(
  function ($) {
		App.init();
  //  loadDoggy(0, "Steve", "0x003f04e2e4", "0.100", "0.200", "0x8aFf4148A9FeB7fB456412095A235BafD8a7787a", false);
  //  loadDoggy(1, "Alfred", "0x003f323ef3", "0.100", "0.200", "0x8aFf4148A9FeB7fB456412095A235BafD8a7787a", false);
  //  loadDoggy(2, "Alfredo", "0x0012123553", "0.100", "0.200", "0x8aFf4148A9FeB7fB456412095A235BafD8a7787a", false);
  }
);
