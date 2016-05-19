Role Name
========

This role installs and setup NFS server.

Requirements
------------

Ansible 1.4 or higher.

Role Variables
--------------

```yaml
nfs_exported_directories: []
```

Dependencies
------------

None.

Example Playbook
-------------------------

```yaml

- role: atsaki.nfs
  nfs_exported_directories:
      - path: /export/test1
        hosts:
          - {name: 192.168.0.0/16, options: ["ro", "sync"]}
          - {name: 10.0.0.5, options: ["rw", "sync", "no_root_squash"]}
      - path: /export/test2
        hosts:
          - {name: "*", options: []}
```

License
-------

BSD

Author Information
------------------

This role was created in 2014 by Atsushi Sasaki (@atsaki).
