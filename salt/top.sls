base:
  '*':
    - util.vim.installed
  'dgs-web-ext-prod*':
    - nginx.confluence
    - confluence
    - postgres.server
    - postgres.manage
