#!/usr/bin/python
'''
    Ansible dynamic inventory script
'''

import json

print(json.dumps({
    'cihosts': {
        'hosts': ['192.168.1.1'],
        'vars': {
            'ansible_connection': 'local',
            'ansible_ssh_user': 'root'}
    }
}))
