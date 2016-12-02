
====
etcd
====

A distributed, reliable key-value store for the most critical data of a distributed system.

Sample pillars
==============

Standalone etcd service
-----------------------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        token: $(uuidgen) 
        members:
        - host: 10.0.175.101
          name: etcd01
          port: 4001

Clustered etcd service
----------------------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        token: $(uuidgen)
        members:
        - host: 10.0.175.101
          name: etcd01
          port: 4001
        - host: 10.0.175.102
          name: etcd02
          port: 4001
        - host: 10.0.175.103
          name: etcd03
          port: 4001

etcd proxy
----------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        proxy: true


etcd on k8s
-----------

.. code-block:: yaml

    etcd:
      server:
        engine: kubernetes

Read more
=========

* https://coreos.com/etcd/
