from django.db import models


class City(models.Model):
    name = models.CharField(verbose_name='наименование', max_length=255)
