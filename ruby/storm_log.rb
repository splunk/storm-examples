#!/usr/bin/env ruby
# Ruby REST Input API for Splunk Storm http://www.splunkstorm.com
#
# = Usage
# 1. Download this script to your local system.
# 2. Obtain your Project ID and Access Token by logging in to your Storm project and navigating to *<Project_Name>* *>* *Inputs* *>* *API*.
# 3. Open this script in a text editor.
# 4. In the _User_ _Options_ section, set *PROJECT_ID* and *ACCESS_TOKEN*.
# 5. Also in _User_ _Options_, set +event_params+'s *sourcetype* and *host*.
# 6. Pipe your data into this script. For example:
#   $ ruby storm-rest-ruby.rb < system.log
#
# = Definitions
# [PROJECT_ID]  Splunk Storm Project ID.
# [ACCESS_TOKEN]  Splunk Storm REST API Access Token.
# [sourcetype]  Format of the event data, e.g. syslog, log4j.
# [host]  Hostname, IP or FQDN from which the event data originated.
#
# = Requires
# * {rest-client gem}[https://github.com/archiloque/rest-client]
#
# = Splunk Storm API Documentation
# * {Use Storms Rest API}[http://docs.splunk.com/Documentation/Storm/latest/User/UseStormsRESTAPI]
#
# = Copyright & License
# Copyright 2012 Splunk, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author:: Splunk Storm Engineering <mailto:support@splunkstorm.com>
# Copyright:: 2012 Splunk, Inc.
# License:: Apache License 2.0.
#


require 'rest-client'


# User Options
PROJECT_ID = 'xxx'
ACCESS_TOKEN = 'yyy'

event_params = {:sourcetype => 'syslog', :host => 'gba.example.com'}


# Nothing to change below
API_HOST = 'api.splunkstorm.com'
API_VERSION = 1
API_ENDPOINT = 'inputs/http'
URL_SCHEME = 'https'

# Actual code
event_params[:project] = PROJECT_ID

api_url = "#{URL_SCHEME}://#{API_HOST}"
api_params = URI.escape(event_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
endpoint_path = "#{API_VERSION}/#{API_ENDPOINT}?#{api_params}"

request = RestClient::Resource.new(
  api_url, :user => 'x', :password => ACCESS_TOKEN)

response = request[endpoint_path].post(ARGF.read)
puts response
