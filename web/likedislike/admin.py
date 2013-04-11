from django.contrib import admin

from likedislike.models import User
from likedislike.models import Poll
from likedislike.models import Vote
from likedislike.models import Registration
from likedislike.models import Comment
from likedislike.models import PollList
from likedislike.models import Hot


admin.site.register(User)
admin.site.register(Poll)
admin.site.register(Vote)
admin.site.register(Registration)
admin.site.register(Comment)
admin.site.register(PollList)
admin.site.register(Hot)
