{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

etcd_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{%- if server.get('engine', 'systemd') == 'kubernetes' %}

etcd_service:
  service.dead:
  - name: etcd
  - enable: False

/var/log/etcd.log:
  file.managed:
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/manifests/etcd.manifest:
  file.managed:
    - source: salt://etcd/files/etcd.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

{%- else %}

etcd_config:
  file.managed:
    - name: {{ server.config }}
    - source: salt://etcd/files/default
    - template: jinja
    - require:
      - pkg: etcd_packages

etcd:
  service.running:
  - enable: True
  - name: {{ server.services }}
  - watch:
    - file: etcd_config

{%- endif %}

{%- endif %}