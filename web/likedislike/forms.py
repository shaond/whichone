#from django.forms import ModelForm
from django import forms
from models import User, Poll, Vote, Registration, Comment


class PollForm(forms.ModelForm):
    class Meta:
        model = Poll
        exclude = ('created', 'uuid', 'votes', 'img1_thumb', 'img2_thumb')


class UserForm(forms.ModelForm):
    class Meta:
        model = User


class VoteForm(forms.ModelForm):
    class Meta:
        model = Vote


class RegistrationForm(forms.ModelForm):
    class Meta:
        model = Registration


class FriendsForm(forms.Form):
    friends = forms.CharField(widget=forms.Textarea,
                required=True, min_length=1)
    uuid = forms.CharField(required=True)


class SendPollToFriendsForm(forms.Form):
    friends = forms.CharField(widget=forms.Textarea,
                required=True, min_length=1)
    uuid = forms.CharField(required=True)
    poll = forms.CharField(required=True)


class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
