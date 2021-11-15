


# Nifty Art

Nifty Art is an exchange where you can buy AI-Generated Art as NFTs! The exchange is built on Django, HTML/CSS, Javascript, and interacts with a Solidity smart contract deployed on the Ropsten Ethereum Test Network. 

# Demo GIFs and Images


https://user-images.githubusercontent.com/59661629/119915302-35fc6180-bf30-11eb-8bfa-dddc48bfdcf1.mov

https://user-images.githubusercontent.com/59661629/119914401-00ef0f80-bf2e-11eb-9ac3-19d6707a3d44.mov

https://user-images.githubusercontent.com/59661629/119915598-d94d7680-bf30-11eb-8818-8c6977134ee1.mov



# Installing Dependencies
In order to start and use the project, you will need [Django](https://docs.djangoproject.com/en/3.2/topics/install/), as well as the [Metamask browser extension](https://metamask.io/download). To install Django on Mac/Linux, run the following command in your terminal:

```
python -m pip install Django
```

To set up Metamask, start by creating a wallet by clicking through the tutorial after you install Metamask. Once you get to the wallet menu, click on the networks dropdown and select "Ropsten Test Network": 

<p align="center">
  <img src="https://user-images.githubusercontent.com/26176104/118428349-3e85aa00-b69d-11eb-950a-0585852882d7.png">
</p>

Once this is done, head to [https://faucet.ropsten.be/](https://faucet.ropsten.be/). Copy and paste your testnet wallet address into the textbox, and click "Send me test Ether" as follows:

![Screen Recording 2021-05-16 at 11 12 41 PM](https://user-images.githubusercontent.com/26176104/118428198-eb135c00-b69c-11eb-839e-332ab7d5dc4e.gif)

You are now ready to start the website and get testing!

# 3. Starting the Website

In order to start the website, navigate to the django-site/ folder in terminal.

```
cd django-site/
```

Then, in the django-site/ directory, enter the following:

```
django manage.py runserver
```
