{%- from "network/map.jinja" import network with context -%}

systemwide_config:
    network.system:
        - enable: True
        - gateway: {{ network.gateway }}
        - hostname: {{ salt['grains.get']('fqdn', 'localhost.local') }}



networkmanager_config:
    {% if network.NM_enabled %}
    service.running:
        - name: NetworkManager
    {% else %}
    service.dead:
        - name: NetworkManager
        - enable: False
    {% endif %}
