jre_install:
    archive.extracted:
        - name: /usr/lib/java
        - source: salt://pkg/server-jre-8u131-linux-x64.tar.gz
        - source_hash: sha256=a80634d17896fe26e432f6c2b589ef6485685b2e717c82cd36f8f747d40ec84b
        - user: root
        - group: root
        - options: --strip-components=1
        - enforce_toplevel: False
