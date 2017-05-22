{%- from "atlassian/map.jinja" import jira with context -%}
{%- from "atlassian/lib.sls" import create_user, create_dir with context %}


{{ create_user(jira.config.user) }}

{{ create_dir(jira.config.install_dir, jira.config.user, jira.config.user) }}
{{ create_dir(jira.config.home_dir, jira.config.user, jira.config.user) }}


