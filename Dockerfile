FROM       httpd:alpine
MAINTAINER Brad Beck <bradley.beck@gmail.com>

USER root

RUN sed \
    -e '/#LoadModule proxy_http_module/ s/^#//' \
    -e '/#LoadModule proxy_module/ s/^#//' \
    -e '/#LoadModule headers_module/ s/^#//' \
    -e '/#LoadModule rewrite_module/ s/^#//' \
    -i /usr/local/apache2/conf/httpd.conf && \
    echo $'<Location /nexus>\n\
RewriteEngine on\n\
RewriteRule .* -\n\
RequestHeader set X-Proxy_REMOTE-USER admin\n\
\n\
RequestHeader unset Authorization\n\
\n\
ProxyPreserveHost on\n\
ProxyPass http://192.168.254.45:8081/nexus\n\
ProxyPassReverse http://192.168.254.45:8081/nexus\n\
</Location>\n' >> /usr/local/apache2/conf/httpd.conf

CMD [ "/bin/sh" ]
