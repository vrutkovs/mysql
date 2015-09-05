#!/usr/bin/python

'''
    Ansible dynamic inventory script
'''

print(str({
    'cihosts': {
        'hosts': ['192.168.1.1'],
        'vars': {}
    }
}))
