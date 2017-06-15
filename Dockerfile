FROM       httpd:alpine
MAINTAINER Brad Beck <bradley.beck@gmail.com>

USER root

RUN sed \
    -e '/#LoadModule proxy_http_module/ s/^#//' \
    -e '/#LoadModule proxy_module/ s/^#//' \
    -e '/#LoadModule headers_module/ s/^#//' \
    -e '/#LoadModule rewrite_module/ s/^#//' \
    -i /usr/local/apache2/conf/httpd.conf && \
    echo 'admin:$apr1$fyMhdpY5$gOiBUNmpSIBt2ZK8RCH2D1' > /usr/local/apache2/passwd && \
    echo 'other:$apr1$BWS1JYMJ$9wa15SfIkF7wq2BYhQEpA/' >> /usr/local/apache2/passwd && \
    echo $'<Location /nexus>\n\
AuthType Basic\n\
AuthName NXRM3\n\
AuthBasicProvider file\n\
AuthUserFile /usr/local/apache2/passwd\n\
Require valid-user\n\

RewriteEngine on\n\
RewriteCond %{REMOTE_USER} (.*)\n\
RewriteRule .* - [E=ENV_REMOTE_USER:%1]\n\
RequestHeader set X-Proxy_REMOTE-USER %{ENV_REMOTE_USER}e\n\
\n\
RequestHeader unset Authorization\n\
\n\
ProxyPreserveHost on\n\
ProxyPass http://nxrm:8081/nexus\n\
ProxyPassReverse http://nxrm:8081/nexus\n\
</Location>\n' >> /usr/local/apache2/conf/httpd.conf
