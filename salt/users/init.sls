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
        {% if 'uid' in items %}
        - uid: {{ items.uid }}
        {% endif %}
        {% if 'gid' in items %}
        - gid: {{ items.gid }}
        {% else %}
        - gid_from_name: True
        {% endif %}
        {% if 'home' in items %}
        - home: {{ items.home }}
        {% endif %}
        {% if 'shell' in items %}
        - shell: {{ items.shell }}
        {% endif %}
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
        {% endif %}

{% if 'publickey' in items %}
ssh_auth-{{ user }}:
    ssh_auth.present:
        - name: {{ items.publickey }}
        - user: {{ user }}
        - enc: {{ items.pktype }}
        - comment: {{ items.pkcomment }}
        - require:
            - user: user-{{ user }}
{% endif %}

{% endfor %}
