{% set confluence_user = salt['pillar.get']('confluence:config:username') %}
{% set install_dir     = salt['pillar.get']('confluence:config:install_dir') %}
{% set home_dir        = salt['pillar.get']('confluence:config:home_dir') %}

confluence_user:
    user.present:
        - name: {{ confluence_user }}
        - system: True
        - createhome: False
        - gid_from_name: True
        - shell: /sbin/nologin

confluence_install_dir:
    file.directory:
        - name: {{ install_dir }}
        - user: {{ confluence_user }}
        - group: {{ confluence_user }}
        - makedirs: True
        - dir_mode: 740

confluence_home_dir:
    file.directory:
        - name: {{ home_dir }}
        - user: {{ confluence_user }}
        - group: {{ confluence_user }}
        - makedirs: True
        - dir_mode: 640

confluence_files_extracted:
    archive.extracted:
        - name: {{ install_dir }}
        - source: salt://confluence/files/atlassian-confluence-6.1.1.tar.gz
        - user: {{ confluence_user }}
        - group: {{ confluence_user }}
        - options: --strip-components=1

confluence_homedir_setting:
    file.managed:
        - name: {{ install_dir }}/confluence/WEB-INF/classes/confluence-init.properties
        - source: salt://confluence/files/confluence-init.jinja
        - template: jinja
        - replace: True
        - user: {{ confluence_user }}
        - group: {{ confluence_user }}
        - mode: 640
        - defaults:
            home_dir: {{ home_dir }}

confluence_server_xml_setting:
    file.managed:
        - name: {{ install_dir }}/conf/server.xml
        - source: salt://confluence/files/server.jinja
        - template: jinja
        - replace: True
        - user: {{ confluence_user }}
        - group: {{ confluence_user }}
        - mode: 640
        - defaults:
            proxy: True
            context_path: {{ salt['pillar.get']('confluence:proxy:context_path') }}
            proxy_name: {{ salt['pillar.get']('confluence:proxy:name') }}
            proxy_port: {{ salt['pillar.get']('confluence:proxy:port') }}
            proxy_scheme: {{ salt['pillar.get']('confluence:proxy:scheme') }}

confluence_systemd_unit:
    file.managed:
        - name: /etc/systemd/system/confluence.service
        - source: salt://confluence/files/service.jinja
        - template: jinja
        - replace: True
        - user: root
        - group: root
        - mode: 640
        - defaults:
            install_dir: {{ install_dir }}
            confluence_user: {{ confluence_user }}
    module.run:
        - name: service.systemctl_reload
        - onchanges:
            - file: confluence_systemd_unit
    service.running:
        - name: confluence.service
        - enable: True
