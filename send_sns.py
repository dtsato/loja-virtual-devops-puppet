#!/usr/bin/env python

# Pre-requisites:
# * Python
# * Boto
# * Tornado
# * Amazon AWS account credentials
# * SNS topic created
#
# Steps to install (on Ubuntu):
# apt-get install python-boto python-tornado
# export AWS_ACCESS_KEY_ID=<your AWS access key id>
# export AWS_SECRET_ACCESS_KEY=<your AWS secret access key>
#
# Usage: printf <msg> | send_sns.py --topic=<topic> --subject=<subject> --region=<region>

import boto.regioninfo
import tornado.options
import sys
import logging
import os

def send_sns(topic, msg, subject):
    region = boto.regioninfo.RegionInfo(name=tornado.options.options.region, endpoint="sns.%s.amazonaws.com" % (tornado.options.options.region))

    sns = boto.connect_sns(os.environ["AWS_ACCESS_KEY_ID"],os.environ["AWS_SECRET_ACCESS_KEY"], region=region)

    arn = ""
    for topics in sns.get_all_topics()["ListTopicsResponse"]["ListTopicsResult"]["Topics"]:
        if topic in topics["TopicArn"]:
            arn = topics["TopicArn"]

    if arn == "":
        logging.error("topic not found!")
        exit(0)

    print sns.publish(arn, msg, subject)

if __name__ == "__main__":

    tornado.options.define("topic", help="specify the destination topic", default="", type=str)
    tornado.options.define("subject", help="specify the subject of the message", default="", type=str)
    tornado.options.define("region", help="specify the AWS region to use", default="us-east-1", type=str)
    tornado.options.parse_command_line()

    if tornado.options.options.topic == "":
        logging.error("No topic specified. use --topic or look at --help for more info.")
        exit(0)

    if "AWS_ACCESS_KEY_ID" not in os.environ or "AWS_SECRET_ACCESS_KEY" not in os.environ:
        logging.error("No AWS credentials specified. Please set the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY")
        exit(0)

    msg = ""

    #message is piped in
    for line in sys.stdin.readlines():
        msg = msg + "\n" + line

    send_sns(tornado.options.options.topic, msg, tornado.options.options.subject)