import uuid

from django.db import models

from core.auth.models import BaseUser
from components.social.verification.models import Verification

from components.government.structures.models import City, Country


class ChannelRoleGroup(models.Model):
    name = models.CharField(max_length=127)
    color = models.CharField(max_length=6)


class ChannelRole(models.Model):
    name = models.CharField(max_length=127)
    group = models.ForeignKey(ChannelRoleGroup, on_delete=models.SET_NULL, default=None, null=True, blank=True)

    def __str__(self):
        return str(self.name)


class ChannelMembership(models.Model):
    user = models.ForeignKey(BaseUser, on_delete=models.CASCADE)
    role = models.ForeignKey(ChannelRole, on_delete=models.SET_NULL, default=None, null=True, blank=True)


class ChannelTopicsGroup(models.Model):
    name = models.CharField(max_length=127)


class ChannelTopics(models.Model):
    name = models.CharField(max_length=127)
    group = models.ForeignKey(ChannelTopicsGroup, on_delete=models.SET_NULL, null=True, blank=True)


class Channel(models.Model):

    class Kind(models.TextChoices):
        PUBLIC = 'public'
        PRIVATE = 'private'
        PERSONAL = 'personal'

    guid = models.UUIDField(default=uuid.uuid4)
    address = models.CharField(max_length=63)

    kind = models.CharField(max_length=63)
    maintainer = models.ForeignKey(BaseUser, on_delete=models.SET_NULL, null=True, blank=True)
    members = models.ManyToManyField(BaseUser, through=ChannelMembership, related_name='channels')

    name = models.CharField(max_length=255)
    description = models.TextField(max_length=1023)
    verification = models.ForeignKey(Verification, on_delete=models.SET_DEFAULT, default=None, null=True, black=True)

    topics = models.ForeignKey(ChannelTopics, on_delete=models.SET_NULL, null=True, blank=True)
    country = models.ForeignKey(Country, on_delete=models.SET_NULL, null=True, blank=True)
    city = models.ForeignKey(City, on_delete=models.SET_NULL, null=True, blank=True)
    website = models.CharField(max_length=255)

    is_hidden = models.BooleanField(default=False)
    is_deleted = models.BooleanField(default=False)
