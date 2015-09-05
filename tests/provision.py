#!/usr/bin/python

'''
    Ansible dynamic inventory script
'''

print(str({
    'cihosts': {
        'hosts': ['192.168.1.1'],
        'vars': {
            'ansible_connection': 'local',
            'ansible_ssh_user': 'root'}
    }
}))
