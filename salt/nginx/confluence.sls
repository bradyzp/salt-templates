{%- from "nginx/map.jinja" import confluence with context -%}

include:
    - nginx.installed

confluence_rproxy:
  file.managed:
    - name: /etc/nginx/conf.d/confluence.conf
    - source: salt://nginx/files/server_tpl.conf
    - user: root
    - group: root
    - mode: 660
    - makedirs: True
    - dir_mode: 660
    - template: jinja
    - context: 
        config: {{ confluence.config|json() }}
    - require:
      - pkg: nginx

default_conf:
    file.absent:
        - name: /etc/nginx/conf.d/default.conf

nginx_service:
    service.running:
        - name: nginx.service
        - enable: True

nginx_test:
    cmd.run:
        - name: nginx -t

nginx_reload:
    cmd.run:
        - name: nginx -s reload
        - onchanges:
            - file: confluence_rproxy
            - file: default_conf
        - require:
            - cmd: nginx_test