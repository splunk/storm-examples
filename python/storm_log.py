#!/usr/bin/env python
"""Splunk Storm Input API Python Example.

Copyright 2012 Splunk, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

__author__ = 'Splunk Storm Engineering <mailto:support@splunkstorm.com>'
__copyright__ = 'Copyright 2012 Splunk, Inc.'
__license__ = 'Apache License 2.0'


import urllib
import urllib2


# Fill the access_token and project_id values from Storm UI
# You'll need to have an existing account with Splunk Storm
# http://www.splunkstorm.com/
ACCESS_TOKEN = '<your access token>'
PROJECT_ID = '<project id>'


class StormLog(object):
    """A simple example class to send logs to a Splunk Storm project.

    Your ``access_token`` and ``project_id`` are available from the Storm UI.
    """

    def __init__(self, access_token, project_id, input_url=None):
        self.url = input_url or 'https://api.splunkstorm.com/1/inputs/http'
        self.project_id = project_id
        self.access_token = access_token

        self.pass_manager = urllib2.HTTPPasswordMgrWithDefaultRealm()
        self.pass_manager.add_password(None, self.url, 'x', access_token)
        self.auth_handler = urllib2.HTTPBasicAuthHandler(self.pass_manager)
        self.opener = urllib2.build_opener(self.auth_handler)
        urllib2.install_opener(self.opener)

    def send(self, event_text, sourcetype='syslog', host=None, source=None):
        params = {'project': self.project_id,
                  'sourcetype': sourcetype}
        if host:
            params['host'] = host
        if source:
            params['source'] = source
        url = '%s?%s' % (self.url, urllib.urlencode(params))
        try:
            req = urllib2.Request(url, event_text)
            response = urllib2.urlopen(req)
            return response.read()
        except (IOError, OSError), ex:
            # An error occured during URL opening or reading
            raise


# Example
# Setup the example logger
# Arguments are your access token and the project ID
log = StormLog(ACCESS_TOKEN, PROJECT_ID)

# Send a log; will pick up the default value for ``source``.
log.send('Apr 1 2012 18:47:23 UTC host57 action=supply_win amount=5710.3',
         sourcetype='syslog', host='host57')
# Will pick up the 'default' value for ``host``.
log.send('Apr 1 2012 18:47:26 UTC host44 action=deliver from=foo@bar.com to=narwin@splunkstorm.com',
         sourcetype='syslog')
