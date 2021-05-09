from django.urls import path

from . import views

# Look at store, and access somethings in these url patterns
app_name = 'store'

# Referenceing a view from a url for the homepages
urlpatterns = [
    path('', views.product_all, name='product_all'),
    path('<slug:slug>', views.product_detail, name='product_detail'),
    path('shop/<slug:category_slug>/',
         views.category_list, name='category_list'),
]
