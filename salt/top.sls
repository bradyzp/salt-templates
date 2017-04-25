base:
  '*':
    - util.vim.installed
  'dgs-web-ext-prod*':
    - util.vim.installed
    - confluence
    - postgres.server
    - postgres.manage
    
