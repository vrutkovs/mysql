FROM rhel7

# MySQL image for OpenShift.
#
# Volumes:
#  * /var/lib/mysql/data - Datastore for MySQL
# Environment:
#  * $MYSQL_USER - Database user name
#  * $MYSQL_PASSWORD - User's password
#  * $MYSQL_DATABASE - Name of the database to create
#  * $MYSQL_ROOT_PASSWORD (Optional) - Password for the 'root' MySQL account

MAINTAINER  Martin Nagy <mnagy@redhat.com>

ENV MYSQL_VERSION=5.5 \
    HOME=/var/lib/mysql

LABEL k8s.io/description="MySQL is a multi-user, multi-threaded SQL database server" \
      k8s.io/display-name="MySQL 5.5" \
      openshift.io/expose-services="3306:mysql" \
      openshift.io/tags="database,mysql,mysql55"

# Labels consumed by Red Hat build service
LABEL Component="mysql55" \
      Name="openshift3/mysql-55-rhel7" \
      Version="5.5" \
      Release="1"

EXPOSE 3306

COPY run-*.sh /usr/local/bin/
COPY contrib /var/lib/mysql/

# This image must forever use UID 27 for mysql user so our volumes are
# safe in the future. This should *never* change, the last test is there
# to make sure of that.
RUN yum install -y yum-utils gettext hostname && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum install -y --setopt=tsflags=nodocs bind-utils mysql55 && \
    yum clean all && \
    mkdir -p /var/lib/mysql/data && chown mysql.mysql /var/lib/mysql/data && \
    test "$(id mysql)" = "uid=27(mysql) gid=27(mysql) groups=27(mysql)" && \
    chmod o+w -R /var/lib/mysql

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=/var/lib/mysql/scl_enable \
    ENV=/var/lib/mysql/scl_enable \
    PROMPT_COMMAND=". /var/lib/mysql/scl_enable"


VOLUME ["/var/lib/mysql/data"]

USER 27

ENTRYPOINT ["run-mysqld.sh"]
CMD ["mysqld"]
