base:
  '*':
    - util.vim.installed
  'rh-c7-confluence*':
    - nginx.confluence
    - atlassian.confluence
    - postgres.server
    - postgres.manage
