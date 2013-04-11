# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'User'
        db.create_table('likedislike_user', (
            ('phone', self.gf('django.db.models.fields.CharField')(max_length=100, primary_key=True)),
            ('uuid', self.gf('django.db.models.fields.CharField')(default='5264ff08-c3bc-4b94-b383-345319bd68ad', unique=True, max_length=150)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('likedislike', ['User'])

        # Adding model 'Poll'
        db.create_table('likedislike_poll', (
            ('uuid', self.gf('django.db.models.fields.CharField')(default='8e02a1c5-3076-4dbb-987d-df0f74b4c55f', unique=True, max_length=150, primary_key=True)),
            ('owner', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.User'])),
            ('desc', self.gf('django.db.models.fields.CharField')(max_length=140)),
            ('img1', self.gf('django.db.models.fields.files.ImageField')(max_length=200)),
            ('img2', self.gf('django.db.models.fields.files.ImageField')(max_length=200, null=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(default=datetime.datetime.now)),
            ('public', self.gf('django.db.models.fields.NullBooleanField')(null=True, blank=True)),
        ))
        db.send_create_signal('likedislike', ['Poll'])

        # Adding model 'Comment'
        db.create_table('likedislike_comment', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('poll', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.Poll'])),
            ('owner', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.User'])),
            ('comment', self.gf('django.db.models.fields.CharField')(max_length=500)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('likedislike', ['Comment'])

        # Adding model 'PollList'
        db.create_table('likedislike_polllist', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('poll', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.Poll'])),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.User'])),
        ))
        db.send_create_signal('likedislike', ['PollList'])

        # Adding model 'Vote'
        db.create_table('likedislike_vote', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('voter', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.User'])),
            ('poll', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['likedislike.Poll'])),
            ('vote', self.gf('django.db.models.fields.IntegerField')(max_length=1)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('likedislike', ['Vote'])

        # Adding model 'Registration'
        db.create_table('likedislike_registration', (
            ('phone', self.gf('django.db.models.fields.CharField')(max_length=100, primary_key=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, auto_now_add=True, null=True, blank=True)),
            ('pin', self.gf('django.db.models.fields.CharField')(max_length=4)),
        ))
        db.send_create_signal('likedislike', ['Registration'])


    def backwards(self, orm):
        
        # Deleting model 'User'
        db.delete_table('likedislike_user')

        # Deleting model 'Poll'
        db.delete_table('likedislike_poll')

        # Deleting model 'Comment'
        db.delete_table('likedislike_comment')

        # Deleting model 'PollList'
        db.delete_table('likedislike_polllist')

        # Deleting model 'Vote'
        db.delete_table('likedislike_vote')

        # Deleting model 'Registration'
        db.delete_table('likedislike_registration')


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
            'public': ('django.db.models.fields.NullBooleanField', [], {'null': 'True', 'blank': 'True'}),
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'1fcd0114-1f03-47ac-9a77-0bdce3e53d3f'", 'unique': 'True', 'max_length': '150', 'primary_key': 'True'})
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
            'uuid': ('django.db.models.fields.CharField', [], {'default': "'6383f209-c5e9-4344-86e3-a1429ecbbbde'", 'unique': 'True', 'max_length': '150'})
        },
        'likedislike.vote': {
            'Meta': {'ordering': "['created', 'poll']", 'object_name': 'Vote'},
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'poll': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.Poll']"}),
            'vote': ('django.db.models.fields.IntegerField', [], {'max_length': '1'}),
            'voter': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['likedislike.User']"})
        }
    }

    complete_apps = ['likedislike']
