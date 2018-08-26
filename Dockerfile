FROM registry.access.redhat.com/rhel7.4
#FROM centos:7
#COPY sclo.repo /etc/yum.repos.d/sclo.repo
WORKDIR /opt/app-root/src
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum-config-manager --enable rhel-7-server-optional-rpms

RUN INSTALL_PKGS="rh-python36 rh-python36-python-devel rh-python36-python-setuptools rh-python36-python-pip nss_wrapper \
        httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
        httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
        yum install -y yum-utils && \
        yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
        rpm -V $INSTALL_PKGS && \
        yum -y clean all --enablerepo='*'
# RUN yum install -y epel-release
RUN yum-config-manager --enable rhel-*-optional-rpms
RUN yum-config-manager --enable rhel-*-extras-rpms
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y R
RUN cd /usr/bin \
	&& ln -s /opt/rh/rh-python36/root/usr/bin/idle idle3 \
	&& ln -s /opt/rh/rh-python36/root/usr/bin/pip pip3 \
	&& ln -s /opt/rh/rh-python36/root/usr/bin/pydoc3 pydoc3 \
	&& ln -s /opt/rh/rh-python36/root/usr/bin/python python3 \
	&& ln -s /opt/rh/rh-python36/root/usr/bin/python-config python3-config
ENV PATH=$PATH;/opt/rh/rh-python36/root/usr/bin
RUN echo $PATH
RUN pip3 install --upgrade pip
RUN pip3 install flask==1.0.2
RUN yum install -y readline-devel
RUN pip3 install rpy2==2.9.4
RUN yum install -y nlopt nlopt-devel
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"))' >> .Rprofile
RUN Rscript -e 'install.packages("nloptr", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'install.packages("nnet",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("caret",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("glmnet",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("Hmisc",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("gridExtra",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("doParallel",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("Matrix",dependencies=TRUE, repos="https://cran.rstudio.com/")' \
	&&Rscript -e 'install.packages("SDMTools",dependencies=TRUE, repos="https://cran.rstudio.com/")' 

ADD . /opt/app-root/src
#RUN cd /src; pip install -r requirements.txt
EXPOSE 8080
COPY index.html /var/run/web/index.html

USER 1001

CMD cd /var/run/web && python3 -m SimpleHTTPServer 8080
#CMD ["python3", "/opt/app-root/src/os-sample-python/config.py"]
#CMD ["python""]


