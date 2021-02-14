FROM public.ecr.aws/lambda/provided:al2

ENV R_VERSION=4.0.3
ENV JDK_VERSION=1.8.0
ENV PATH="${PATH}:/opt/R/${R_VERSION}/bin/"

# install requried R packages
RUN yum -y install \
        wget \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && wget https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm \
    && yum -y install R-${R_VERSION}-1-1.x86_64.rpm \
    && rm R-${R_VERSION}-1-1.x86_64.rpm \
    && yum -y install openssl-devel

# install and configure java requirement for rJava package
RUN yum -y install java-${JDK_VERSION}-openjdk-devel \
    && R CMD javareconf

# install R packages
RUN Rscript -e "install.packages(c('httr', 'jsonlite', 'logger', 'glue', 'rJava', 'SqlRender'), repos = 'https://cloud.r-project.org/')"

COPY runtime.R functions.R ${LAMBDA_TASK_ROOT}/
COPY bootstrap /var/runtime/bootstrap

RUN chmod 755 -R ${LAMBDA_TASK_ROOT}/ \
    && chmod +x /var/runtime/bootstrap

CMD [ "functions.split" ]
