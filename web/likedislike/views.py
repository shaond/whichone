import uuid
import json
import bisect
import datetime
import random
import urllib
import urllib2

from django.http import HttpResponse, Http404
from django.shortcuts import render, redirect
from django.shortcuts import render_to_response, get_object_or_404
from django.views.decorators.cache import never_cache
from django.views.decorators.csrf import csrf_exempt
from django.core.files.uploadedfile import SimpleUploadedFile
from django.core import serializers
from pyapns import configure, provision, notify

import settings
from models import Poll, PollList, User, Vote, Registration
from forms import *


def homepage(request):
    return HttpResponse('\'ello')


def test(request):
    return render_to_response('postjson.html')


def generate_pin(length):
    """Returns a PIN of length 'length'"""
    import string
    import random
    return [''.join(random.choice(string.digits) for x in xrange(length))]


def send_notification(token, message):
    """Sends a notification via PyAPNS."""
    # notification = {'whichone': {
    #                     'sound': 'default',
    #                     'badge': 0,
    #                     'message': str(message),
    #                     }
    #                 }
    notification = {'aps': {'alert': 'You have a new poll!'}}
    notify('whichone', token, notification)
    print 'Token: %s\nMessage: %s' % (token, notification)


@never_cache
def add_poll(request):
    if request.method == 'POST':
        poll_form = PollForm(request.POST, request.FILES)
        if poll_form.is_valid():
            poll = poll_form.save()
            return HttpResponse(json.dumps(poll.uuid),
                    mimetype='application/json')
        else:
            return HttpResponse(json.dumps('fail'),
                    mimetype='application/json')
    elif request.method == 'GET':
        poll_form = PollForm()
        return render(request, 'createpoll.html', {'poll_form': poll_form})


@never_cache
def add_vote(request, uuid, polluuid, choice):
    if request.method == 'GET':
        try:
            vote = Vote.objects.get(voter=uuid, poll=polluuid)
            return HttpResponse(json.dumps('fail: vote exists'),
                        mimetype='application/json')
        except Vote.DoesNotExist:
            vote = Vote()
            _poll = Poll.objects.get(uuid=polluuid)
            vote.voter = User.objects.get(uuid=uuid)
            vote.poll = _poll
            vote.vote = choice
            vote.save()
            _poll.votes = _poll.votes + 1
            _poll.save()
            return HttpResponse(json.dumps('ok'),
                        mimetype='application/json')
    else:
        raise Http404


@never_cache
def add_friends_to_poll(request):
    if request.method == 'POST':
        form = SendPollToFriendsForm(request.POST)
        if form.is_valid():
            formdata = form.cleaned_data['friends']
            friends = json.loads(formdata)
            if User.objects.filter(uuid=form.cleaned_data['uuid']).exists():
                _poll = Poll.objects.get(uuid=form.cleaned_data['poll'])
                whichfriends = [f for f in friends if
                    User.objects.filter(phone=f['phone']).exists()]
                for friend in whichfriends:
                    _f = User.objects.get(phone=friend['phone'])
                    pl = PollList(user=_f, poll=_poll)
                    pl.save()
                return HttpResponse(json.dumps(whichfriends, sort_keys=True,
                        indent=2, ensure_ascii=True),
                        mimetype='application/json')
    if request.method == 'GET':
        form = SendPollToFriendsForm()
        return render(request, 'sendpolltofriends.html', {'form': form})
    else:
        raise Http404


@never_cache
def add_comment(request):
    if request.method == 'GET':
        form = CommentForm()
        return render(request, 'commentform.html', {'form': form})
    if request.method == 'POST':
        form = CommentForm(request.POST)
        if form.is_valid():
            comment = form.save()
            if request.is_ajax():
                return HttpResponse(json.dumps('ok'),
                        mimetype='application/json')
            else:
                return HttpResponse('Thanks, comment recorded.')
        else:
            return HttpResponse(json.dumps('fail'),
                    mimetype='application/json')


@never_cache
def add_devicetoken(request, uid, token):
    if request.method == 'GET':
        u = User.objects.get(uuid=uid)
        u.device_token = str(token)
        u.save()
        send_notification(str(token), 'Hello mate')
        return HttpResponse(str(token), mimetype='application/json')
    else:
        return HttpResponse('fail', mimetype='application/json')


@never_cache
def get_poll(request, polluuid):
    '''Returns the JSON serialized Poll object.'''
    if request.method == 'GET':
        data = serializers.serialize('json', Poll.objects.filter(
            uuid=polluuid), fields=('owner', 'desc', 'img1', 'img2'),
            ensure_ascii=False)
        return HttpResponse(data,
                mimetype='application/json')
    else:
        return redirect('homepage')


@never_cache
def get_mypolls(request, uid):
    '''Gets a list of all the Polls the user has created themselves.'''
    if request.method == 'GET':
        u = User.objects.get(uuid=uid)
        polls = Poll.objects.filter(owner=u)
        data = serializers.serialize('json', polls,
                    fields=('uuid', 'img1', 'img2', 'votes', 'desc',
                    'img1_thumb', 'img2_thumb', 'public', 'owner'),
                    ensure_ascii=False)
        return HttpResponse(data, mimetype='application/json')


@never_cache
def get_pollform(request, polluuid):
    '''A debug view of the Poll'''
    if request.method == 'GET':
        poll = Poll.objects.get(uuid=polluuid)
        users = User.objects.all()
        random_user = users[random.randint(0, users.count() - 1)].uuid
        return render_to_response('viewpoll.html', {'poll': poll, 'uploaddir':
            settings.MEDIA_URL, 'random_user': random_user})


@csrf_exempt
def get_friends(request):
    '''Compares a list of contacts from the phone to those on the server.

    The mobile phone POSTs a JSON list of sanitised contacts which gets parsed
    and compared against all registered users on the server.

    Args:
        None

    Returns:
        A JSON response with a list of phone numbers which also have the
        application installed.

    Raises:
        A HTTP 404 if the POST does not fit the correct (valid) criteria.
    '''

    if request.method == 'POST':
        form = FriendsForm(request.POST)
        if form.is_valid():
            formdata = form.cleaned_data['friends']
            friends = json.loads(formdata)
            if User.objects.filter(uuid=form.cleaned_data['uuid']).exists():
                whichfriends = [f for f in friends if
                    User.objects.filter(phone=f['phone']).exists()]
                return HttpResponse(json.dumps(whichfriends, sort_keys=True,
                        indent=2, ensure_ascii=True),
                        mimetype='application/json')
            else:
                raise Http404
        else:
            return HttpResponse(json.dumps('fail'),
                    mimetype='application/json')
    if request.method == 'GET':
        form = FriendsForm()
        return render_to_response('getfriends.html', {'form': form})


def get_hot(request):
    '''Gets the top X most popular Polls over this week'''
    if request.method == 'GET':
        polls = Poll.objects.filter(public=True)\
                        .order_by('created')\
                        .order_by('votes')[:16]
        data = serializers.serialize('json', polls, fields=('uuid', 'votes',
                'img1_thumb'))
        return HttpResponse(data,
                    mimetype='application/json')
    else:
        raise Http404


def get_comments(request, pollid):
    if request.method == 'GET':
        comments = Comment.objects.filter(poll=pollid)
        data = serializers.serialize('json', comments)
        return HttpResponse(data,
                    mimetype='application/json')
    else:
        return HttpResponse('fail')


@never_cache
def send_poll(request):
    pass


@never_cache
def add_phone(request, phone):
    '''Adds a new phone to our list of users and sends a verification SMS.

    Args:
        phone: mobile phone number in the format - 00 area_code phone_number
        eg. 0061424387059

    Returns:
        JSON status, either 'ok' or 'fail'.

    Raises:
        None
    '''

    if request.method == 'GET':
        registration = Registration()
        registration.phone = phone
        registration.pin = generate_pin(4)[0]
        registration.save()

        if sendsms(phone, registration.pin):
            return HttpResponse(json.dumps('ok'), mimetype='application/json')
        else:
            return HttpResponse(json.dumps('fail'),
                    mimetype='application/json')
    else:
        return HttpResponse(json.dumps('fail'),
                mimetype='application/json')


def sendsms(phone, pin):
    '''Sends an SMS to registrants via the Nexmo service.

    Args:
        phone: The phone number to send the SMS
        pin: The PIN code to send the phone no# above.

    Returns:
        True: if successfully sent an SMS
        False: if something went wrong

    Raises:
        None
    '''

    BASE_URL = 'http://rest.nexmo.com/sms/json?'
    USERNAME = 'aa865355'
    PASSWORD = '406762c0'
    FROM = 'whichone'

    query_args = {'username': USERNAME,
                  'password': PASSWORD,
                  'from': FROM,
                  'to': phone,
                  'text': "Your whichone PIN is: %s" % pin}

    encoded_args = urllib.urlencode(query_args)
    url = BASE_URL + encoded_args

    try:
        sms = urllib2.urlopen(url)
        print sms.read()
        return True
    except URLError, HTTPError:
        # We should be handling this case differently
        return False
    except:
        return False


@never_cache
def validation(request, _phone, _pin):
    rego = get_object_or_404(Registration, phone=_phone)
    if int(rego.pin) == int(_pin):
        try:
            user = User.objects.get(phone=_phone)
            return HttpResponse(json.dumps('%s' % user.uuid),
                        mimetype='application/json')
        except User.DoesNotExist:
            newuser = User()
            newuser.phone = str(_phone)
            newuser.uuid = str(uuid.uuid4())
            newuser.save()
            rego.delete()
            return HttpResponse(json.dumps('%s' % newuser.uuid),
                mimetype='application/json')
    else:
        return HttpResponse(json.dumps('fail'), mimetype='application/json')
