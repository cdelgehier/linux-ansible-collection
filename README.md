# Ansible Collection - cdelgehier.linux

Documentation for the collection.

## Using roles in this collection.

1. Install the collection:

```shell
ansible-galaxy collection install cdelgehier.linux
```

You can also list a collection in `requirements.yml`:

```yaml
---
collections:
  - name: cdelgehier.linux
```

2. Include roles in your playbooks:

```yaml
---
- hosts: all
  tasks:
    - name: users
      import_role:
        name: cdelgehier.linux.ansible-role-motd
```
