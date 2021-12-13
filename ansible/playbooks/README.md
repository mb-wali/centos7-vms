# Playbooks
Ansible playbooks are blueprint of automation tasks.

## Writing a Playbook
if you run this playbook it will install **nano** in all the servers.
```yml
---
- hosts: all # which host
  become: true # become the default `sudo`
  tasks:
  - name: install nano package  # task title
    yum:    # module we want to use
      name: nano    # name of the package
      state: latest # (optional): install or update the existing to latest
```
**States for module**
* **state: latest**: will update the specified package if it's not of the latest available version.
* **state: absent**:  will remove the specified package.
* **state: present**: will simply ensure that a desired package is installed.
* **state: installed**: will simply ensure that a desired package is installed.
* **state: removed**: will remove the specified package.

**Tasks**
* **pre_task**: These tasks needs to run before anyother tasks
* **post_task**: These tasks needs to run after other tasks.

### The 'when' Conditional
Run a playbook on certain conditions.
This will run only if the OS is CentOS.
we can basically use anykind of variables.
```yml
---
- hosts: all
  ....
    yum:
      name: nano
    when: ansible_distribution == "CentOS" # run only to CentOS OS
```

**if you want to check against multiple distributions:**
```yml
---
- hosts: all
  ....
    apt:
      name: nano
    when: ansible_distribution in ["Ubuntu", "Debian"] # run only on defined value for OS
```

**if you want to use multiple variables**
```yml
---
- hosts: all
  ....
    yum:
      name: nano
    when: ansible_distribution == "CentOS" and ansible_distribution_version == "7"
```

### (TODO:)Variables
in ansible variable are inside `{}`.
* **"{string_variable}"** string varibles are always in double qoutes.
declaring ??

### Package module
package module is a generic package manager, whatever package manager the underline host or target server uses.
its practical to use if the package name is not different in operating systems.
```yml
---
- hosts: all 
  become: true
  tasks:
  - name: install nano package
    package:    # generic package manager
      name: nano
```

### Tags
Use `tags` to add some metadata to our plays, that makes our testing playbook easier to run.
**tags: always** this will run always.

```yml
---
- hosts: all
  become: true
  pre_tasks: # run this first
  - name: install nano package
    tags: centos, editor # run only if these tags are specified
    yum:
      name: nano
      state: latest
```
**list avalible tags in a playbook**
```bash
ansible-playbook --list-tags playbook.yml
```

**run the playbook with tags**
```bash
ansible-playbook --tags tagname playbook.yml
```

### Managing Files
use ansible to copy files to the servers.

**create a play to copy a file, using copy module**
```yml
---
- hosts: webservers
  become: true
  tasks: 
  - name: copy default html template
    copy:
      src: filename.extention # name of file and the file should b in a directory `files`
      dest: /var/www/html/file # path to your server
      owner: root
      group: root
      mode: 0644  # permission
```

### Managing Services
Managing services in servers such as docker, httpd and so on.
**service** module allow us to manage services in our linux machines.
```yml
---
- hosts: all
  become: true
  tasks:
  - name: install httpd package
    yum:
      name: httpd
  # after installing we need to start it
  - name: start httpd service
    service:
      name: httpd
      state: started # start the service
      enabled: yes # enable the service
```



### Change a line in a file
**lineinfile** module allow you to change a line of code in a file.
```yml
---
- hosts: mail 
  become: true
  tasks:
  - name: change e-mail address for admin
    lineinfile: # this module allow you to change the line
      path: /etc/path/filename.extention # path to the file
      regexp: '^ServerAdmin' # regular expression - the beginning of the line
      line: ServerAdmin new_email@example.com # change to this
    register: httpd # this module allows ansible to capture a state in to a variable # httpd is the variable name

  - name: restart httpd
    service:
      name: httpd
      state: restarted  # restart the service
    when: httpd.changed # using the register module variable, run when that change has happend.
```

### Ansible User Management
**user** module is used for creating a user that will run our tasks.

Creating a user:
```yml
---
- hosts: all
  become: true
  tasks:
  - name: create user
    user:
      name: simone # name of the user
      groups: root # adding this user to root group
```

**configure this user to run ansible jobs**
&
**authorized_key** module is meant to do this job.

Adding ssh-key for this user:
```yml
---
- hosts: all
  become: true
  tasks:
  - name: add ssh key for simone
    authorized_key:
      user: simone # name of the user
      key: "<past the public ssh key>"
```

**add sudoers file for simone**
this will allow the user simone to run commands with sudo.
```yml
---
- hosts: all
  become: true
  tasks:
  - name: add sudoers file for simone
    copy:
      src: /path/file # content of the file = # simone ALL=(ALL) NOPASSWD: ALL
      dest: /etc/sudoers.d/simone # path to the servers
      owner: root
      group: root
```

to access the server with this created user type:
```bash
ssh simone@127.10.14.125
```

#### change ansible config to use simone user
**ansible.cfg**
```cfg
[defaults]
remote_user = simone
```

## Roles
Roles let you automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure.

**Creating roles,** 
* We need a new directory called `roles`.
* Inside this directory make a directory for each roles. e.g. `roles/nano`.
* And then we will create a task directory, e.g. `roles/nano/tasks`.
inside our tasks directory we will put our playbooks or also called `task_books`.
* create main.yml e.g. `roles/nano/tasks/main.yml` - which is a **task book** meaning it contains only tasks,
  and add your tasks.
  ```yml
  ---
  - name: install nano package
    yum:
      name: nano
      state: latest
  ```

**Using roles**

inside your playbook we can just add the **roles**, and it will pick the role by the name from `roles/<name>/tasks/main.yml`.

```yml
---
- hosts: all
  become: true
  roles:
    - nano
```

https://www.youtube.com/watch?v=tq9sCeQNVYc&list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70&index=14

## (TODO) Using Variables
Ansible uses variables to manage differences between systems. With Ansible, you can execute tasks and playbooks on multiple different systems with a single command. To represent the variations among those different systems, you can create variables with standard YAML syntax, including lists and dictionaries. You can define these variables in your playbooks, in your inventory, in re-usable files or roles, or at the command line. You can also create variables during a playbook run by registering the return value or values of a task as a new variable.

After you create variables, either by defining them in a file, passing them at the command line, or registering the return value or values of a task as a new variable, you can use those variables in module arguments, in conditional “when” statements, in templates, and in loops.

### (TODO) Host Variables
create a directory that holds the variables, `/host_vars`.
this will holds our inventory hosts. lets create one for webservers.

## Handlers: running operations on change
Sometimes you want a task to run only when a change is made on a machine. For example, you may want to restart a service if a task updates the configuration of that service, but not if the configuration is unchanged. Ansible uses handlers to address this use case. Handlers are tasks that only run when notified. Each handler should have a globally unique name.

**e.g.**
```yml
---
  # task
  - name: Write the apache config file
    ansible.builtin.template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:     # task should notify the handler, and it should match the name of handler
    - Restart apache

  # handler   # this handler runs only if the task above is executed.
    handlers:
      - name: Restart apache
        service:
          name: httpd
          state: restarted
```



## Templates
Ansible templates allow you to define text files with variables instead of static values and then replace those variables at playbook runtime.
An Ansible template is a text file built with the Jinja2 templating language with a `j2` file extension.

```yml
---
  - name: use template to replace a file
    template:    # module we want to use
      src: /path/template
      dest: /dest/path 
      owner: root
      group: root
      mode: 0644
```

**(TODO)e.g.** 

## Available Plabooks

**enable-start-docker.yml**
Docker is already installed on your vms, this playbook will enable and start the docker daemon.

```shell
ansible-playbook ./playbooks/enable-docker/enable-start-docker.yml
```
* Start & Enable Docker - docker is pre-installed via Dockerfile
