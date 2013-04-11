# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding field 'Poll.votes'
        db.add_column('likedislike_poll', 'votes', self.gf('django.db.models.fields.PositiveIntegerField')(null=True, blank=True), keep_default=False)

        # Changing field 'Poll.public'
        db.alter_column('likedislike_poll', 'public', self.gf('django.db.models.fields.BooleanField')())


    def backwards(self, orm):
        
        # Deleting field 'Poll.votes'
        db.delete_column('likedislike_poll', 'votes')

        # Changing field 'Poll.public'
        db.alter_column('likedislike_poll', 'public', self.gf('django.db.models.fields.NullBooleanField')(null=True))


    models = {
        'likedislike.comment': {
            'Meta': {'ordering': "['poll', 'owner', 'created']", 'object_name': 'Comment'},
            'comment': ('django.db.models.fields.CharField', [], {'max_length': '500'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'owner': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"}),
            'poll': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"})
        },
        'likedislike.poll': {
            'Meta': {'ordering': "['owner', 'uuid']", 'object_name': 'Poll'},
            'created': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'desc': ('django.db.models.fields.CharField', [], {'max_length': '140'}),
            'img1': ('django.db.models.fields.files.ImageField', [], {'max_length': '200'}),
            'img2': ('django.db.models.fields.files.ImageField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'owner': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"}),
            'public': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'522fd963-caf0-4424-a20c-08be2a049f17'", 'unique': 'True', 'max_length': '150', 'primary_key': 'True'}),
            'votes': ('django.db.models.fields.PositiveIntegerField', [], {'null': 'True', 'blank': 'True'})
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
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'bd1f1ec9-a124-40c5-b47c-c1729b211979'", 'unique': 'True', 'max_length': '150'})
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
