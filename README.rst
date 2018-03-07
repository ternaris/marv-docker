Example MARV site
=================

This is an exemplary setup of a MARV site using the experimental MARV Community Edition docker image.

The published docker image is built with the contained `<./.dockerfile>`_.

This is meant for easy evaluation and publication of minimal working examples to reproduce issues.


Setup
-----

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


Reporting issues / Minimal working example
------------------------------------------

In order to provide a minimal working example to reproduce issues you are seeing, please:

1. Create a fork of this repository and clone it
2. adjust configuration in `<./etc>`_ accordingly
3. if there is custom code involved, please add a minimal working example based on it to a python package in `<./addons>`_. We don't need to see your real code, but we cannot help without code.
4. create a ``scanroot`` folder and add minimal bags or other log files as needed
5. make sure the site exposes the issue(s) you are seeing
6. Push your changes to your fork
7. Create an issue in https://github.com/ternaris/marv-robotics/issues and reference your fork in it.


Errors
------

::

   [uwsgi-ssl] unable to assign certificate /etc/marv//uwsgi-ssl.crt for context "http-:8443"

This means uwsgi could not find the SSL certificate which should be
right next to ``etc/uwsgi.conf`` (see above).


Further reading
---------------

- MARV Robotics `website <https://ternaris.com/marv-robotics/>`_
- MARV Robotics `documentation <https://ternaris.com/marv-robotics/docs/>`_
