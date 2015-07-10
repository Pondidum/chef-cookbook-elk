#
# Cookbook Name:: elk
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'

include_recipe 'elk::elasticsearch'
include_recipe 'elk::kibana'
include_recipe 'elk::nginx'
