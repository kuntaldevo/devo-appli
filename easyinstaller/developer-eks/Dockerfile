FROM devops-application/base-tooling:latest

COPY pull-n-run.sh /root/pull-n-run.sh
RUN chmod 777 /root/pull-n-run.sh

CMD /root/pull-n-run.sh $BRANCH_NAME up
