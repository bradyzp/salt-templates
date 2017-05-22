{% macro create_user(name, shell='/bin/bash', system='True' -%}
{{ name }}_user:
  user.present:
    - name: {{ name }}
    - system: {{ system }}
    - createhome: True
    - shell: {{ shell }}
{%- endmacro %}

{% macro create_dir(path, uowner, gowner, dir_mode=740, file_mode=640) -%}
{{ path }}_dir:
  file.directory:
    - name: {{ path }}
    - user: {{ uowner }}
    - group: {{ gowner }}
    - makedirs: True
    - dir_mode: {{ dir_mode }}
    - file_mode: {{ file_mode }}
    - recurse:
      - user
      - group
      - mode
{%- endmacro %}

{% macro extract(source, dest_path, 
