#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Script to toggle a Zulip Realm's to day/night modes"""

import argparse
import glob
import os
import threading

import zulip

# # Edit a message
# # (make sure that message_id below is set to the ID of the
# # message you wish to update)
# # https://park.zulipchat.com/#narrow/stream/124034-general/topic/welcome/near/

# # Get the 100 last messages sent by "iago@zulip.com" to the stream "Verona"
# request = {
#     "anchor": start,
#     "num_after": 1000,
# "narrow": ,
# }  # type: Dict[str, Any]
# result = client.get_messages(request)
# print(result)


# request =
# result = client.update_message(request)
# print(result)


def change_topic(client, start, end, new_topic):
    # Get first message and figure out stream and topic
    filters = {"id": start, "num_before": 0, "num_after": 0, "anchor": start}
    response = client.get_messages(filters)

    message = response["messages"][0]
    stream_id = message["stream_id"]
    topic = response["messages"][0]["subject"]
    streams = client.get_streams()["streams"]
    stream = [
        stream for stream in streams if stream["stream_id"] == stream_id
    ][0]

    # Get messages in the topic
    filters = {
        "narrow": [
            {"operator": "stream", "operand": stream["name"]},
            {"operator": "topic", "operand": topic},
        ],
        "num_before": 0,
        "num_after": 1000,
        "anchor": start,
    }
    response = client.get_messages(filters)
    messages = [
        message
        for message in response["messages"]
        if start <= message["id"] <= end
    ]
    for msg in messages:
        request = {
            "message_id": msg["id"],
            "topic": new_topic,
            "send_notification_to_old_thread": False,
            "send_notification_to_new_thread": False,
        }
        result = client.update_message(request)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config-path", "-c", type=open, required=True)
    parser.add_argument("--start", "-a", type=int, required=True)
    parser.add_argument("--end", "-z", type=int, required=True)
    parser.add_argument("--new-topic", "-t", type=str, required=True)

    options = parser.parse_args()
    config_path = options.config_path.name
    new_topic = options.new_topic.strip()
    start = options.start
    end = options.end
    client = zulip.Client(config_file=config_path)
    assert start < end
    change_topic(client, start, end, new_topic)


if __name__ == "__main__":
    main()
