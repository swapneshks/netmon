#!/bin/bash

proc_stat=$(ps aux | grep netmon | grep -v grep)

if [ ! -z "$proc_stat" ]; then
	ps aux | grep netmon | grep -v grep | awk '{print $2}' | xargs kill -9
fi

ps aux | grep datausagenotify | grep -v grep | awk '{print $2}' | xargs kill -9
ps aux | grep chknethogs | grep -v grep | awk '{print $2}' | xargs kill -9

