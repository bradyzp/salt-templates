confluence_rproxy:
    file.managed:
        - name: /etc/nginx/conf.d/confluence.conf
        - source: salt://nginx/files/confluence.conf
        - user: root
        - group: root
        - mode: 660
        - makedirs: True
