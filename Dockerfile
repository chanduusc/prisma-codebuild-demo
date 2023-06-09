FROM public.ecr.aws/docker/library/ubuntu:18.04
COPY wild.py /
RUN apt update -y
RUN apt install python3-pip git curl wget node-hawk node-minimist -y
RUN pip3 --no-cache-dir install --upgrade awscli boto3
RUN pip3 install gitpython
EXPOSE 8080 
ENTRYPOINT [ "python3", "wild.py"]
