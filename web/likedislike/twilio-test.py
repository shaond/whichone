from twilio.rest import TwilioRestClient

ACCOUNT_SID = 'AC7854afb88d824ff0a7e3c7a637e9eb6a'
AUTH_TOKEN = '6b881b189e221e81a8c6040ac157ce99'

client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)
message = client.sms.messages.create(to='+61424387059',
                                     from_='+14158304314', 
                                     body='Testing') 
