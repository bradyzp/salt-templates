{% set sudo_grp = salt['grains.filter_by'](
    {
        'Debian': 'sudo',
        'RedHat': 'wheel'
    },
    grain='os_family',
) %}


{%- for user, items in salt['pillar.get']('users').iteritems() %}
{% if 'groups' in items %}
{% for group, gid in items.groups.iteritems() %}
group-{{ gid }}:
    group.present:
        - name: {{ group }}
        - gid: {{ gid }}
        - require_in:
            - user-{{ user }}
{% endfor %}
{% endif %} 

user-{{ user }}:
    user.present:
        - name: {{ items.name }}
        - uid: {{ items.uid }}
        {% if 'gid' in items %}
        - gid: {{ items.gid }}
        {% else %}
        - gid_from_name: True
        {% endif %}
        - home: {{ items.home }}
        - shell: {{ items.shell }}
        {%- if user.password is defined %}
        - password: {{ items.password }}
        {% endif %}
        - groups:
        {% if 'sudoer' in items and items.sudoer == true %}
            - {{ sudo_grp }}
        {% endif %}
        {% if 'groups' in items %}
            {% for group in items.groups %}
            - {{ group }}
            {% endfor %}
        {% else %}
            - {{ user }}
        {% endif %}

{% if 'pubkey' in items and items.pubkey == true %}
ssh_auth-{{ user }}:
    ssh_auth.present:
        - user: {{ user }}
        - enc: ssh-rsa
        - source: salt://users/keys/{{ user }}-id_rsa.pub
        - require:
            - user: user-{{ user }}
{% endif %}

{% endfor %}
