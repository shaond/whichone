import os
import uuid
import settings
import datetime

from PIL import Image
from django.db import models


VOTETYPE = (
    (1, 'Image 1'),
    (2, 'Image 2'),
)


def generate_filename(instance, filename):
    extension = filename.split('.')[-1]
    filename = "%s.%s" % (uuid.uuid4(), extension)
    return filename


def generate_uuid():
    return str(uuid.uuid4())


class User(models.Model):
    uuid = models.CharField(default=generate_uuid, max_length=150,
            blank=False, null=False, unique=True, primary_key=True)
    phone = models.CharField(max_length=100)
    created = models.DateTimeField(auto_now_add=True)
    karma = models.IntegerField(default=0, null=False)
    device_token = models.CharField(max_length=200, blank=True, null=True,
            unique=False)

    def __unicode__(self):
        return u'%s' % (self.phone)

    class Meta:
        ordering = ['created']


class Poll(models.Model):
    uuid = models.CharField(default=generate_uuid, max_length=150,
            blank=False, null=False, unique=True, primary_key=True)
    owner = models.ForeignKey(User)
    desc = models.CharField(max_length=140)
    img1 = models.ImageField(upload_to=generate_filename, max_length=200)
    img2 = models.ImageField(upload_to=generate_filename, max_length=200,
            blank=True, null=True)
    img1_thumb = models.ImageField(upload_to=generate_filename,
                    blank=True, null=True, max_length=200)
    img2_thumb = models.ImageField(upload_to=generate_filename,
                    blank=True, null=True, max_length=200)
    created = models.DateTimeField(default=datetime.datetime.now)
    public = models.BooleanField(default=False)
    votes = models.PositiveIntegerField(default=0, null=False)

    def save(self):
        super(Poll, self).save()
        size = 612,612
        thumbsize = 150,150
        if self.img1:
            path = settings.MEDIA_ROOT + '/' + str(self.img1)
            thumb_path = settings.MEDIA_ROOT + '/thumbnails/' + str(self.img1) 

            img1 = Image.open(path)
            img1.thumbnail(size, Image.ANTIALIAS)
            img1_thumb = img1.resize(thumbsize, Image.ANTIALIAS)

            # save our images here
            img1.save(path)
            img1_thumb.save(thumb_path)

            self.img1_thumb = 'thumbnails/' + str(self.img1)
        if self.img2:
            path = settings.MEDIA_ROOT + '/' + str(self.img2)
            thumb_path = settings.MEDIA_ROOT + '/thumbnails/' + str(self.img2) 

            img2 = Image.open(path)
            img2.thumbnail(size, Image.ANTIALIAS)
            img2_thumb = img2.resize(thumbsize, Image.ANTIALIAS)

            # save our images here
            img2.save(path)
            img2_thumb.save(thumb_path)

            self.img2_thumb = 'thumbnails/' + str(self.img2)
        super(Poll, self).save()

    def __unicode__(self):
        return '[%s]: %s' % (self.owner, self.desc)

    class Meta:
        ordering = ['owner', 'uuid']


class Hot(models.Model):
    uuid = models.ForeignKey(Poll)
    img1_thumb = models.ImageField(upload_to=generate_filename, max_length=200)
    img2_thumb = models.ImageField(upload_to=generate_filename, max_length=200,
                    blank=True, null=True)
    votes = models.IntegerField(blank=False, null=False)
    created = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return '%u' % uuid

    class Meta:
        verbose_name_plural = 'Hot'


class Comment(models.Model):
    poll = models.ForeignKey(Poll)
    owner = models.ForeignKey(User)
    comment = models.CharField(max_length=500)
    created = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return '[%s]: %s' % (self.owner, self.comment)

    class Meta:
        ordering = ['poll', 'owner', 'created']


class PollList(models.Model):
    '''Tracks Polls a user has been invited to vote on.'''
    poll = models.ForeignKey(Poll)
    user = models.ForeignKey(User)

    def __unicode__(self):
        return '[%s] - %s' % (self.poll, self.user)

    class Meta:
        ordering = ['user', 'poll']
        verbose_name_plural = 'Poll List'


class Vote(models.Model):
    voter = models.ForeignKey(User)
    poll = models.ForeignKey(Poll)
    vote = models.IntegerField(max_length=1, choices=VOTETYPE)
    created = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return '%s: %s' % (self.poll, self.vote)

    class Meta:
        ordering = ['poll', 'created']


class Registration(models.Model):
    phone = models.CharField(max_length=100, primary_key=True)
    created = models.DateTimeField(auto_now=True, auto_now_add=True, null=True)
    pin = models.CharField(max_length=4)

    def __unicode__(self):
        return '[%s | %s]' % (self.phone, self.created)

    class Meta:
        ordering = ['phone']
