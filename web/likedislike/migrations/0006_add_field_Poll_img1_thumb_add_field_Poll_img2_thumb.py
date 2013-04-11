# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding field 'Poll.img1_thumb'
        db.add_column('likedislike_poll', 'img1_thumb', self.gf('django.db.models.fields.files.ImageField')(max_length=200, null=True, blank=True), keep_default=False)

        # Adding field 'Poll.img2_thumb'
        db.add_column('likedislike_poll', 'img2_thumb', self.gf('django.db.models.fields.files.ImageField')(max_length=200, null=True, blank=True), keep_default=False)


    def backwards(self, orm):
        
        # Deleting field 'Poll.img1_thumb'
        db.delete_column('likedislike_poll', 'img1_thumb')

        # Deleting field 'Poll.img2_thumb'
        db.delete_column('likedislike_poll', 'img2_thumb')


    models = {
        'likedislike.comment': {
            'Meta': {'ordering': "['poll', 'owner', 'created']", 'object_name': 'Comment'},
            'comment': ('django.db.models.fields.CharField', [], {'max_length': '500'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'owner': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"}),
            'poll': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"})
        },
        'likedislike.hot': {
            'Meta': {'object_name': 'Hot'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'img1_thumb': ('django.db.models.fields.files.ImageField', [], {'max_length': '200'}),
            'img2_thumb': ('django.db.models.fields.files.ImageField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'uuid': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"}),
            'votes': ('django.db.models.fields.IntegerField', [], {})
        },
        'likedislike.poll': {
            'Meta': {'ordering': "['owner', 'uuid']", 'object_name': 'Poll'},
            'created': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'desc': ('django.db.models.fields.CharField', [], {'max_length': '140'}),
            'img1': ('django.db.models.fields.files.ImageField', [], {'max_length': '200'}),
            'img1_thumb': ('django.db.models.fields.files.ImageField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'img2': ('django.db.models.fields.files.ImageField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'img2_thumb': ('django.db.models.fields.files.ImageField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'owner': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"}),
            'public': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'f633e363-41a6-4b56-a21a-036fafe1bcaf'", 'unique': 'True', 'max_length': '150', 'primary_key': 'True'}),
            'votes': ('django.db.models.fields.PositiveIntegerField', [], {'default': '0'})
        },
        'likedislike.polllist': {
            'Meta': {'ordering': "['user', 'poll']", 'object_name': 'PollList'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'poll': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"})
        },
        'likedislike.registration': {
            'Meta': {'ordering': "['phone']", 'object_name': 'Registration'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'auto_now_add': 'True', 'null': 'True', 'blank': 'True'}),
            'phone': ('django.db.models.fields.CharField', [], {'max_length': '100', 'primary_key': 'True'}),
            'pin': ('django.db.models.fields.CharField', [], {'max_length': '4'})
        },
        'likedislike.user': {
            'Meta': {'ordering': "['created']", 'object_name': 'User'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'phone': ('django.db.models.fields.CharField', [], {'max_length': '100', 'primary_key': 'True'}),
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'c5cd815f-2133-43ef-a2b6-c309808adc63'", 'unique': 'True', 'max_length': '150'})
        },
        'likedislike.vote': {
            'Meta': {'ordering': "['poll', 'created']", 'object_name': 'Vote'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'poll': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"}),
            'vote': ('django.db.models.fields.IntegerField', [], {'max_length': '1'}),
            'voter': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"})
        }
    }

    complete_apps = ['likedislike']
