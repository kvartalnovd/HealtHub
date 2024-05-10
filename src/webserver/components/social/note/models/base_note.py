import uuid

from django.db import models


class BaseNote(models.Model):
    guid = models.UUIDField(verbose_name='id', default=uuid.uuid4)
