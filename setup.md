- Create collection
`ansible-galaxy collection init cdelgehier.linux`
- `cd linux/roles`
- Create role
`molecule init role --driver-name docker --verifier-name ansible ansible-role-users`
- Write the molecule test
```yaml
- name: Verify
  hosts: all
  gather_facts: false
  vars_files:
    - variables.yml

  tasks:
    - name: User exist ?
      ansible.builtin.user:
        name: "{{ item.username }}"
        state: present
      check_mode: true   #  dry run
      register: user
      failed_when: user is changed or user is failed
      with_items: "{{ users_list }}"
```
- Write the converge.yml
```yaml
- name: Converge
  hosts: all
  vars_files:
    - variables.yml

  tasks:
    - name: "Include ansible-role-users"
      ansible.builtin.include_role:
        name: "ansible-role-users"
```
- Code the feature
- Create container `molecule converge`
- Verify tests `ANSIBLE_VERBOSITY=2 molecule verify`
