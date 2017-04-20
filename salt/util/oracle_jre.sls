jre_install:
    archive.extracted:
        - name: /usr/lib/java
        - source: salt://util/pkg/server-jre-8u121-linux-x64.tar.gz
        - source_hash: sha256=c25a60d02475499109f2bd6aa483721462aa7bfbb86b23ca6ac59be472747e5d
        - user: root
        - group: root
        - options: --strip-components=1
        - enforce_toplevel: False
