#!/bin/bash
# This is a script called from Vagrantfile to set up the guest

# Install Rails packages for simple demo app
sudo yum install rubygem-{rails,sqlite3,coffee-rails,sass-rails,uglifier,jquery-rails,turbolinks,jbuilder,therubyracer,sdoc,spring} -y

# PostgreSQL client
sudo yum install rubygem-pg -y
sudo yum install postgresql -y
