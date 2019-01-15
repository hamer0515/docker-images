FROM hamer/alpine-glibc
    
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
    ORACLE_SID=XE \
    INSTALL_FILE_1="oracle-database-xe-18c-1.0-1.x86_64.rpm" \
    RUN_FILE="runOracle.sh" \
    PWD_FILE="setPassword.sh" \
    CONF_FILE="oracle-xe-18c.conf" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    INSTALL_DIR="/tmp" \
    ORACLE_DOCKER_INSTALL="true" \
    PATH=$ORACLE_HOME/bin:$PATH \
    ORACLE_PWD="oracle"

COPY $INSTALL_FILE_1 $RUN_FILE $PWD_FILE $CHECK_DB_FILE $CONF_FILE $INSTALL_DIR/

RUN apk --update add --no-cache bash libarchive-tools && \
    bsdtar -C / -xf ${INSTALL_DIR}/${INSTALL_FILE_1} && \
    addgroup oinstall && adduser -D -G oinstall -h ${ORACLE_BASE} -s /bin/false oracle && \
    chown -R oracle:oinstall ${ORACLE_BASE} && \
    mkdir -p ${ORACLE_BASE}/scripts/{setup, startup} && \
    ln -s ${ORACLE_BASE}/scripts /docker-entrypoint-initdb.d && \
    mkdir -p ${ORACLE_BASE}/oradata && \
    chown -R oracle:oinstall ${ORACLE_BASE}/oradata && \
    mv ${INSTALL_DIR}/$RUN_FILE ${ORACLE_BASE}/ && \
    mv ${INSTALL_DIR}/$PWD_FILE ${ORACLE_BASE}/ && \
    mv ${INSTALL_DIR}/$CHECK_DB_FILE ${ORACLE_BASE}/ && \
    mv ${INSTALL_DIR}/${CONF_FILE} /etc/sysconfig/ && \
    ln -s ${ORACLE_BASE}/${PWD_FILE} / && \
    target_txt=$(cat /etc/security/limits.d/oracle-database-preinstall-18c.conf | grep -e 'oracle *hard *memlock*') && \
    sed -i "/^$target_txt/ c#$target_txt" /etc/security/limits.d/oracle-database-preinstall-18c.conf && \
    chmod ug+x ${ORACLE_BASE}/*.sh && \
	rm -f ${INSTALL_DIR}/${INSTALL_FILE_1}

VOLUME ["${ORACLE_BASE}/oradata"]

EXPOSE 1521 8080 5500

HEALTHCHECK --interval=1m --start-period=5m \
   CMD "${ORACLE_BASE}/${CHECK_DB_FILE}" >/dev/null || exit 1

CMD exec ${ORACLE_BASE}/${RUN_FILE}
