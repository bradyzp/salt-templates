{%- from 'firewalld/map.jinja' import firewall with context -%}

include:
    - firewalld.pkg


iptables_disabled:
    service.dead:
        - name: iptables
        - enable: False

firewalld_enabled:
    service.running:
        - name: firewalld
        - enable: True
        - require:
            - service: iptables_disabled

{# This cmd runs only if called from watch statement #}
firewalld_reload:
    cmd.wait:
        - name: 'firewall-cmd --reload'
        - require:
            - service: firewalld_enabled

{% for name, zone in firewall.iteritems() %}
zone_{{ name }}:
    firewalld.present:
        - name: {{ name }}
        {% for directive, value in zone.iteritems() %}
        - {{ directive }}:
            {%- if value is not sequence %}
            {{ value }}
            {% else %}
            {% for item in value %}
            - {{ item }}
            {% endfor %}
            {% endif %}
        {% endfor %}
        - require:
            - pkg: firewalld_pkg
        - watch_in:
            - service: firewalld_reload
{% endfor %}

