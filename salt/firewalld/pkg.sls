# firewalld/pkg.sls
# Ensure firewalld package is installed

firewalld_pkg:
    pkg.installed:
        - name: firewalld
