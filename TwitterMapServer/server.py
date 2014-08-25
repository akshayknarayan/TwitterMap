from flask import Flask
from flask import request, redirect, Response, jsonify

import tweepy
import aes
import stream

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello, World!"

consumer_token = "YOUR_TOKEN_HERE"
consumer_secret = "YOUR_SECRET_HERE"
sessions = {}

@app.route('/auth')
def auth():
    auth = tweepy.OAuthHandler(consumer_token, consumer_secret)
    try:
        redirect_url = auth.get_authorization_url()
        sessions[auth.request_token.key] = auth.request_token.secret
        return redirect(redirect_url)
    except tweepy.TweepError:
        return 'failed to get request token.'

@app.route('/auth/callback')
def authCallback():
    oauth_token = request.args.get('oauth_token')
    oauth_verifier = request.args.get('oauth_verifier')
#     print "called back!"
    try:
        request_secret = sessions[oauth_token]
        del sessions[oauth_token]
    except KeyError:
        return "request token not recognized"
    #now rebuild auth state
    auth = tweepy.OAuthHandler(consumer_token, consumer_secret)
    auth.set_request_token(oauth_token, request_secret)
    #now try to get access token
    try:
        auth.get_access_token(oauth_verifier)
    except tweepy.TweepError:
        print 'access fail'
        return "failed to get access token."
    #now we need to securely return the access token and secret to the os x app
    access_key = auth.access_token.key
    access_secret = auth.access_token.secret
    message = access_key + " " + access_secret
    return Response(aes.encrypt(message), mimetype = 'text/plain')

@app.route('/tweets')
def tweets():
    searchTerm = request.args.get('filter') #search term
    print 'searched for: ', searchTerm
    auth = request.args.get('auth') #encrypted access key, token passed from client app
    auth = auth.replace(' ', '+')
    access = aes.decrypt(auth).split() #access[0] is key, access[1] is secret
    auth = tweepy.OAuthHandler(consumer_token, consumer_secret)
    auth.set_access_token(access[0], access[1])

    return Response(stream.streamTweets(auth, searchTerm))

if (__name__ == '__main__'):
    app.run(debug=True)
