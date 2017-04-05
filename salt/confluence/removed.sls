{% set confluence_user = salt['pillar.get']('confluence:config:username') %}
{% set install_dir = salt['pillar.get']('confluence:config:install_dir') %}
{% set home_dir = salt['pillar.get']('confluence:config:home_dir') %}

confluence_service_stopped:
    service.dead:
        - name: confluence.service
        - enable: False
        - require_in:
            - file: confluence_install_dir_absent
            - file: confluence_home_dir_absent
            - file: confluence_systemd_unit_absent

confluence_install_dir_absent:
    file.absent:
        - name: {{ install_dir }}

confluence_home_dir_absent:
    file.absent:
        - name: {{ home_dir }}

confluence_systemd_unit_absent:
    file.absent:
        - name: /etc/systemd/system/confluence.service
    module.run:
        - name: service.systemctl_reload
        - onchanges:
            - file: confluence_systemd_unit_absent

confluence_user_absent:
    user.absent:
        - name: {{ confluence_user }}
