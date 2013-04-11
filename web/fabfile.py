import socket
import os
import pwd
import getpass

from fabric.api import *
from fabric.contrib import *
from fabric.context_managers import *
from fabric.utils import *


def localhost():
    env.hosts = ['localhost']


def production():
    env.hosts = ['sagarmatha.funkhq.com']
    env.deploy_user = 'whichone'
    env.directory = 'application'
    env.activate = '%s/bin/activate'


def start():
    localhost()
    local('git pull')
    local('python manage.py runserver', capture=False)


def archive():
    local('git archive HEAD --format=zip > whichone.zip')


def virtualenv(command):
    with cd(env.directory):
        run(env.activate + '&&' + command, user=env.deploy_user)


@hosts('whichone@sagarmatha.funkhq.com')
def deploy():
    foldername = 'application'
    production()
    archive()
    put('whichone.zip')
    with cd('%s' % foldername):
        # run('python manage.py dumpdata --indent=2 > /tmp/dbdump.json')
        with settings(warn_only=True):
            run('kill -9 `cat /tmp/django.pid`')
            run('rm /tmp/django.pid')
        run('mv likedislike.db /tmp/likedislike.db')
    run('rm -rf %s' % foldername)
    run('unzip whichone.zip -d %s' % foldername)
    with cd('%s' % foldername):
        # run('mv /tmp/dbdump.json initial_data.json')
        run('mv /tmp/likedislike.db .')
        run('python manage.py syncdb --noinput')
        run('python manage.py migrate likedislike')
        run('python manage.py collectstatic --noinput')
        run('python manage.py runfcgi method=threaded host=127.0.0.1' \
                ' port=8000 pidfile=/tmp/django.pid' \
                ' outlog=/var/log/whichone/access.log' \
                ' errlog=/var/log/whichone/error.log')
    run('rm whichone.zip')
    local('rm whichone.zip')


@hosts('whichone@sagarmatha.funkhq.com')
def bootstrap():
    foldername = 'application'
    production()
    archive()
    put('whichone.zip')
    local('python manage.py dumpdata --indent=2 > dbdump.json')
    put('dbdump.json')
    run('rm -rf %s' % foldername)
    run('unzip whichone.zip -d %s' % foldername)
    run('pip install -r %s/pip_requirements' % (foldername))
    with cd('%s' % foldername):
        run('mv ~/dbdump.json initial_data.json')
        run('python manage.py syncdb --noinput')
        run('python manage.py collectstatic --noinput')
        run('python manage.py runfcgi method=threaded host=127.0.0.1'
                ' port=8000 pidfile=/tmp/django.pid')
    run('rm whichone.zip')
    local('rm whichone.zip')
    local('rm dbdump.json')
