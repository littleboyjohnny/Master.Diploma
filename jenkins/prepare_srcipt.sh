#!/bin/bash

if [ -z $(docker images -q docker_check_image) ]; then docker build --tag docker_check_image docker_check_image/; fi
if [ -z $(docker images -q sast_image) ]; then docker build --tag sast_image sast_image/; fi
if [ -z $(docker images -q dependency_check_image) ]; then docker build --tag dependency_check_image dependency_check_image/; fi
if [ -z $(docker images -q check_secrets_image) ]; then docker build --tag check_secrets_image check_secrets_image/; fi
