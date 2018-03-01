Experimental docker container for MARV Community Edition
========================================================

See also:

- MARV Robotics `website <https://ternaris.com/marv-robotics/>`_
- MARV Robotics `documentation <https://ternaris.com/marv-robotics/docs/>`_


Setup
-----

This is experimental and meant only for easy evaluation of MARV.

Generate self-signed certificate::
   
   openssl genrsa -out etc/uwsgi-ssl.key 2048
   openssl req -new -key etc/uwsgi-ssl.key -out etc/uwsgi-ssl.csr
   openssl x509 -req -days 3650 -in etc/uwsgi-ssl.csr -signkey etc/uwsgi-ssl.key -out etc/uwsgi-ssl.crt

Enable https in ``etc/uwsgi.conf``::

  [uwsgi]
  http = :8000
  https = :8443,%d/uwsgi-ssl.crt,%d/uwsgi-ssl.key
  ...

Build and start container::

   MARV_SCANROOT=path/to/your/bags ./build.sh

Marv will be served by uwsgi on port 8000 and 8443 for https.


Errors
------

::

   [uwsgi-ssl] unable to assign certificate /etc/marv//uwsgi-ssl.crt for context "http-:8443"

This means uwsgi could not find the SSL certificate which should be
right next to ``etc/uwsgi.conf`` (see above).
