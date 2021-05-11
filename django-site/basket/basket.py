from decimal import Decimal
from store.models import Product


class Basket():

    def __init__(self, request):
        # We are grabbing information from the request, it has the session in it
        self.session = request.session
        # Gets the session of the user, name is skey
        basket = self.session.get('skey')
        # If there is no session active, build a session in 'basket'
        if 'skey' not in request.session:
            # Default session number
            basket = self.session['skey'] = {}
        # Setting the basket data
        self.basket = basket

    # Adds product to basket
    def add(self, product, qty):
        """
        Adding and updating the users basket session data
        """
        product_id = str(product.id)

        if product_id in self.basket:
            self.basket[product_id]['qty'] = qty
        else:
            self.basket[product_id] = {'price': str(product.price), 'qty': qty}
        self.save()

    def __iter__(self):
        # Get the ids of products from our basket in the current session
        product_ids = self.basket.keys()
        # Go through the database and filter out the products that have the product ids we have in our basket
        products = Product.products.filter(id__in=product_ids)
        basket = self.basket.copy()

        # Loop through our products
        for product in products:
            # Add to the basket, a key called product, and add the actual product as the value (to the product.id)
            basket[str(product.id)]['product'] = product

        for item in basket.values():
            # Changing price from str to decimal
            item['price'] = Decimal(item['price'])
            # Adding a new key called total_price, and adding the total price of the product to it
            item['total_price'] = item['price'] * item['qty']
            yield item
    # Gets the basket data and count the qty of items
    # Referenced by basket|length in base.html

    def __len__(self):
        # Iterate over the basket, looking for the item quantity, and get the sum of all of them
        return sum(item['qty'] for item in self.basket.values())

    def get_total_price(self):
        return sum(Decimal(item['price']) * item['qty'] for item in self.basket.values())

    # Delete item from basket (session data)
    def delete(self, product):
        product_id = str(product)
        if product_id in self.basket:
            del self.basket[product_id]
            self.save()

    def save(self):
        self.session.modified = True
