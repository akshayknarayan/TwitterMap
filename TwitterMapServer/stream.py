from flask import json
from threading import Thread
from Queue import Queue

import requests
import tweepy

import sentiment

class TweetStreamListener(tweepy.StreamListener):
    def __init__(self, callback = None):
        def print_fn(x):
            print x
        self.callback = callback if callback else print_fn
        self.sentimenter = sentiment.Sentiment()
    def on_error(self, error):
        print 'error', error
        return True
    def on_data(self, data):
        data = json.loads(data)
        tweet = {}
        convert = lambda x:x.encode('utf-8') if x else None
        tweet['username'] = '@' + convert(data[u'user'][u'screen_name'])
        tweet['text'] = convert(data[u'text'])
        tweet['time'] = convert(data[u'created_at'])
        tweet['location'] = data[u'coordinates']
        
        tweet['sentiment'] = self.sentimenter.matchText(tweet['text'])

        self.callback(tweet)

def streamTweets(auth, filter):
    tweetQueue = Queue()
    def callback(tweet):
        print tweet
        tweetQueue.put(tweet)
    listener = TweetStreamListener(callback)

    def runner(auth, filter, listener):
        streamer = tweepy.Stream(auth = auth, listener = listener)
        streamer.filter(track = [filter])
    t = Thread(target=runner, args=(auth,filter,listener))
    t.start()

    while (True):
        result = json.dumps(tweetQueue.get()) + '\n'
        try:
            yield result
        except:
            tweetQueue = None #cause an exception in the thread, making it quit
