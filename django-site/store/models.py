from django.db import models
from django.urls import reverse
from django.conf import settings

# Over-rides the objects model manager
# Gets any query we want, but filters for only active products
class ProductManager(models.Manager):
    def get_queryset(self):
        return super(ProductManager, self).get_queryset().filter(is_active=True)


class Category(models.Model):
    name = models.CharField(max_length=255, db_index=True)
    # Allows us to reference a certain product in the URL
    slug = models.SlugField(max_length=255, unique=True)

    class Meta:
        verbose_name_plural = 'categories'  # Make sure Category is spelt categories

    def get_absolute_url(self):
        return reverse('store:category_list', args=[self.slug])

    def __str__(self):
        return self.name  # Allows us to reference data from database by its name

# Build a link between product and category table, we can reference a category with a foreign key


class Product(models.Model):
    # There has to be a category in the database, if no category data, delete it
    category = models.ForeignKey(
        Category, related_name='product', on_delete=models.CASCADE)
    # Building a foreign key for the user table that django makes, tells who created a product
    create_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='product_creator')
    title = models.CharField(max_length=255)
    artist = models.CharField(max_length=255, default='admin')
    description = models.TextField(blank=True)
    # Storing the link to the image for a product
    image = models.ImageField(upload_to='images/')
    slug = models.SlugField(max_length=255)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    in_stock = models.BooleanField(default=True)
    # MIGHT NOT NEED IS_ACTIVE
    is_active = models.BooleanField(default=True)
    created = models.DateTimeField(auto_now_add=True)
    # So we can record any updates for a product
    updated = models.DateTimeField(auto_now=True)
    objects = models.Manager()
    products = ProductManager()

    class Meta:
        verbose_name_plural = 'Products'
        # For sorting how we want the data that is returned from the database
        # Descending order
        ordering = ('-created',)

    def get_absolute_url(self):
        return reverse('store:product_detail', args=[self.slug])

    # When we return some data, it will give us the title
    def __str__(self):
        return self.title
