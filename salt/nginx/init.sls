nginx_repo:
    pkgrepo.managed:
    - humanname: NGINX Official Repo
    - name: nginx
    - baseurl: http://nginx.org/packages/centos/7/$basearch/
    - gpgcheck: 0
    - require_in:
        - pkg: nginx

nginx:
    pkg.installed
