{% set confluence_user = salt['pillar.get']('confluence:config:username') %}
{% set install_dir = salt['pillar.get']('confluence:config:install_dir') %}
{% set home_dir = salt['pillar.get']('confluence:config:home_dir') %}

{%- from "confluence/map.jinja" import confluence with context -%}

confluence_service_dead:
    service.dead:
        - name: confluence.service
        - enable: False

confluence_remove_home:
    file.absent:
        - name: {{ confluence.config.home_dir }}
        - require:
            - service: confluence_service_dead

confluence_remove_install:
    file.absent:
        - name: {{ confluence.config.install_dir }}
        - require:
            - service: confluence_service_dead

confluence_systemd_unit_absent:
    file.absent:
        - name: /etc/systemd/system/confluence.service
    module.run:
        - name: service.systemctl_reload
        - onchanges:
            - file: confluence_systemd_unit_absent

confluence_user_absent:
    user.absent:
        - name: {{ confluence.config.user }}
        - require:
            - service: confluence_service_dead
