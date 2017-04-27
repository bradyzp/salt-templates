base:
  '*':
    - util.vim.installed
  'dgs-web-prod*':
    - nginx.confluence
    - confluence
    - postgres.server
    - postgres.manage
