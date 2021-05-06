from django.shortcuts import get_object_or_404, render

from .models import Category, Product

# Takes in a user request
# Creates a homepage that shows everthing in the database for now


def product_all(request):
    products = Product.products.all()  # Select is_active from Products (in SQL)
    return render(request, 'store/home.html', {'products': products})


def product_detail(request, slug):
    # Gets an individual item from the database, where the slug of the item is the same slug passed into the fuction
    product = get_object_or_404(Product, slug=slug, in_stock=True)
    return render(request, 'store/products/single.html', {'product': product})


def category_list(request, category_slug):
    category = get_object_or_404(Category, slug=category_slug)
    products = Product.objects.filter(category=category)
    return render(request, 'store/products/category.html', {'category': category, 'products': products})
