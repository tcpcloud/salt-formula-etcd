{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

etcd_packages:
  pkg.installed:
    - names: {{ server.pkgs }}

/tmp/etcd:
  file.directory:
      - user: root
      - group: root

copy-etcd-binaries:
  dockerng.running:
    - image: {{ server.get('image', 'quay.io/coreos/etcd:latest') }}
    - entrypoint: cp
    - command: -vr /usr/local/bin/ /tmp/etcd/
    - binds:
      - /tmp/etcd/:/tmp/etcd/
    - force: True
    - require:
      - file: /tmp/etcd

{%- for filename in ['etcd', 'etcdctl'] %}

/usr/local/bin/{{ filename }}:
  file.managed:
     - source: /tmp/etcd/bin/{{ filename }}
     - mode: 755
     - user: root
     - group: root
     - require:
       - dockerng: copy-etcd-binaries

{%- endfor %}

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
    - makedirs: True
    - dir_mode: 755

{%- else %}

/etc/default/etcd:
  file.managed:
    - source: salt://etcd/files/default
    - template: jinja

user-etcd:
  user.present:
    - name: etcd
    - shell: /bin/false
    - home: /var/lib/etcd/
    - gid_from_name: True
    - system: True

/etc/systemd/system/etcd.service:
  file.managed:
    - source: salt://etcd/files/systemd/etcd.service
    - template: jinja
    - user: root
    - group: root
    - mode: 644

etcd:
  service.running:
  - enable: True
  - name: {{ server.services }}
  - watch:
    - file: /etc/default/etcd
    - file: /usr/local/bin/etcd
    - file: /etc/systemd/system/etcd.service
    - user: user-etcd

{%- endif %}

{%- endif %}
