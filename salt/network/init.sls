{%- from "network/map.jinja" import network with context -%}

systemwide_config:
    network.system:
        - enabled: True
        - gateway: {{ network.gateway }}
        - hostname: {{ salt['grains.get']('fqdn', 'localhost.local') }}
