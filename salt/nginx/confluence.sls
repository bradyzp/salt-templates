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
    - template: jinj
    - content: {{ confluence.server}}
    - require:
      - pkg: nginx

default_conf:
    file.absent:
        - name: /etc/nginx/conf.d/default.conf
