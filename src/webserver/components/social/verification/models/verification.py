import uuid

from django.db import models


class Verification(models.Model):
    guid = models.UUIDField(verbose_name='id', default=uuid.uuid4)
