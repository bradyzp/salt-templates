{%- from "network/map.jinja" import network with context -%}

systemwide_config:
    network.system:
        - enabled: True
        - gateway: {{ network.gateway }}
        - hostname: {{ salt['grains.get']('fqdn', 'localhost.local') }}



networkmanager_config:
    {% if network.NM_enabled %}
    service.running:
        - name: NetworkManager
    {% else %}
    service.dead:
        - name: NetworkManager
        - enabled: False
    {% endif %}
