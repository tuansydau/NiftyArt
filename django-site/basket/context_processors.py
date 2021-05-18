from .basket import Basket


def basket(request):
    # You can access the basket data through 'basket', its a dictionary
    return {'basket': Basket(request)}
