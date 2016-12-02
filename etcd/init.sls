
{%- if pillar.etcd is defined %}
include:
{%- if pillar.etcd.server is defined %}
- etcd.server
{%- endif %}
{%- if pillar.etcd.server.setup is defined %}
- etcd.setup
{%- endif %}
{%- endif %}
