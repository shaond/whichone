import os

from django.conf.urls.defaults import patterns, include, url
from django.contrib import admin

import settings


admin.autodiscover()
urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),

    # Add URLs
    url(r'^add/poll$', 'likedislike.views.add_poll'),
    url(r'^add/vote/(?P<uuid>[a-z0-9-]+)/'
         '(?P<polluuid>[a-z0-9-]+)/(?P<choice>[1-2]{1})$',
        'likedislike.views.add_vote'),
    url(r'^add/phone/(?P<phone>\d{13})$',
        'likedislike.views.add_phone'),
    url(r'^add/comment$', 'likedislike.views.add_comment', 
            name='add_comment'),
    url(r'^add/friendstopoll$', 'likedislike.views.add_friends_to_poll'),
    url(r'^add/devicetoken/(?P<uid>[a-z0-9-]+)/(?P<token>[a-z0-9]+)$', 'likedislike.views.add_devicetoken'),

    # Validate your mobile
    url(r'^validate/(?P<_phone>\d+)/(?P<_pin>\d{4})$',
        'likedislike.views.validation'),

    # GET URLs
    url(r'^get/poll/(?P<polluuid>[a-z0-9-]+)$',
                'likedislike.views.get_poll'),
    url(r'get/mypolls/(?P<uid>[a-z0-9-]+)$', 'likedislike.views.get_mypolls'),
    url(r'^get/friends$', 'likedislike.views.get_friends'),
    url(r'^get/hot$', 'likedislike.views.get_hot'),
    url(r'^get/comments/(?P<pollid>[a-z0-9-]+)$',
                'likedislike.views.get_comments'),
)

if settings.DEBUG:
    urlpatterns += patterns('',

        # Static files
        (r'^css/(?P<path>.*)$', 'django.views.static.serve', {'document_root':
            os.path.abspath(os.path.join('assets/css/'))}),
        (r'^js/(?P<path>.*)$', 'django.views.static.serve', {'document_root':
            os.path.abspath(os.path.join('assets/js/'))}),
        (r'^img/(?P<path>.*)$', 'django.views.static.serve', {'document_root':
            os.path.abspath(os.path.join('assets/img/'))}),
        (r'^uploads/(?P<path>.*)$', 'django.views.static.serve',
            {'document_root': os.path.abspath(os.path.join(os.curdir, '..', 'uploads'))}),

        # Debugging views
        (r'^debug/poll/(?P<polluuid>[a-z0-9-]+)$',
            'likedislike.views.get_pollform'),
        # (r'^debug/user$', 'likedislike.views.add_user'),
        )
