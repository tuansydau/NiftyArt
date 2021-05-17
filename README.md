# 1. Nifty Art

Nifty Art is an exchange where you can be AI-Generated Art as NFTs! The exchange is built on Django, HTML/CSS, Javascript, and interacts with a Solidity smart contract on the Ropsten Ethereum Test Network. 

# 2. Demo GIFs and Images

# p3. Starting the server
In order to start and use the project, you will need [Django](https://docs.djangoproject.com/en/3.2/topics/install/), as well as the [Metamask browser extension](https://metamask.io/download). To install Django on Mac/Linux, run the following command in your terminal:

```
python -m pip install Django
```

To set up Metamask, start by creating a wallet by clicking through the tutorial after you install Metamask. Once you get to the wallet menu, click on the networks dropdown and select "Ropsten Test Network": 

![image](https://user-images.githubusercontent.com/26176104/118425691-b355e580-b697-11eb-9606-0e79cdbf00d9.png)
118425691-b355e580-b697-11eb-9606-0e79cdbf00d9.png![image](https://user-images.githubusercontent.com/26176104/118428349-3e85aa00-b69d-11eb-950a-0585852882d7.png)


Once this is done, head to [https://faucet.ropsten.be/](https://faucet.ropsten.be/), paste in your test wallet address, and click "Send me test Ether" as follows:

![Screen Recording 2021-05-16 at 11 12 41 PM](https://user-images.githubusercontent.com/26176104/118428198-eb135c00-b69c-11eb-839e-332ab7d5dc4e.gif)

You are now ready to start the website and get testing!

# 3. How to Start the Website

In order to start the website, navigate to the django-site/ folder in terminal, and then enter the following:

```
django manage.py runserver
```

# 4. Additional Insights

## Web Development
This E-commerce website was designed and implemented in Python, HTML/CSS and JavaScript by alborzdev. The **Django** framework was used for the back-end portion of the site, and the **Boostrap** library was used for the front-end. Our goal with the website was to be able to display the art peices in full view on the front page and allow customers to:

* Easily view details on an art peice 
* Add it to their cart
* Check-out with Meta-Mask (a cryptocurrency payment app). 

The site also allows users to create an account to view their previously purchased pieces.

#### alborzdev Insights: 
This was my first time developing a full website so I had to find a place where I could start. We first had a front page written in HTML before we quickly realized we would need an extensive back-end to run the website; that is where Django came in. I found an amazing tutorial on youtube made by Very Academy [[1]](https://www.youtube.com/channel/UC1mxuk7tuQT2D0qTMgKji3w), he provided an amazing, in depth tutorial on how to write an E-commerce back-end & front-end using Django and Boostrap [[2]](https://www.youtube.com/channel/UC1mxuk7tuQT2D0qTMgKji3w). I closely followed the tutorial minute by minute, coding everything from scratch alongside the video ensuring I was learning as much as possible. The code in our program closely ressembles the tutorial, while also being tweaked in many places as the tutorial was about designing a book store, while our website was an art gallery. Later in the tutorial I felt confident to make many changes to the code to make the website our own. These include the one time purchase of art peices, implementing purchasing using meta mask, front-end tweaks to ensure art would be displayed properly, and a few more tweaks here and there. I plan to use this website's back-end as something to look back on and resuse in future projects as it is an amazing base for any E-commerce store, and website in general.

## NFT Implementation

## Generating Art with Tensorflow

## Website Demonstration


[1] https://www.youtube.com/channel/UC1mxuk7tuQT2D0qTMgKji3w

[2] https://www.youtube.com/watch?v=UqSJCVePEWU&list=PLOLrQ9Pn6caxY4Q1U9RjO1bulQp5NDYS_
