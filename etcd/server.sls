{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

etcd_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{%- if server.engine == 'kubernetes' %}

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

{%- endif %}

{%- if server.engine == 'systemd' %}

/etc/default/etcd:
  file.managed:
  - source: salt://etcd/files/default
  - template: jinja
  - require_in:
    - pkg: etcd_packages

etcd_service:
  service.running:
  - enable: True
  - name: {{ server.service }}
  - watch:
    - file: /etc/default/etcd
  - require:
    - pkg: etcd_packages

{%- endif %}

{%- endif %}
