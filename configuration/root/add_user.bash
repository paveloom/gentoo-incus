#!/usr/bin/env bash

useradd user --home-dir /home/user --no-create-home --uid 1000
chown -R user:user /home/user
