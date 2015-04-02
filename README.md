# Yardstick Docker
Yardstick Docker is a set of docker images which contains benchmarks written on top of Yardstick framework.

## Yardstick Framework
Visit <a href="https://github.com/gridgain/yardstick" target="_blank">Yardstick Repository</a> for detailed information
on how to run Yardstick benchmarks and how to generate graphs.

## Running Benchmarks

For running benchmark need to start `servers` and `client`

* `Server` is the remote standalone instance that the `Client` communicates with.
* `Client` is an instance of the benchmark that performs some operation that needs to be tested. 

1.Pull latest docker image for server.

    # docker pull yardstickbenchmarks/yardstick-server

2.Run container from server image.

    # docker run -it --net=host -e GIT_REPO=*url repo* yardstickbenchmarks/yardstick-server
    
    where GIT_REPO mandatory argument and GIT_BRANCH is optional. GIT REPO is url to yardstick benchmark project.

3.Pull latest docker image for client.

    # docker pull yardstickbenchmarks/yardstick-client

4.Run container from client image.

    # docker run -it --net=host -e GIT_REPO=*url repo* -e GIT_BRANCH=*git branch* -v *dir*:/mnt yardstickbenchmarks/yardstick-client
    
    where dir is absolute path to folder where will be uploaded results.

## Running Benchmarks in AWS
### Amazon EC2 console
The easiest way to run benchmarks in AWS is an using created AMI image.

#### Run benchmark server

1. Open the Amazon EC2 console.
2. From the Amazon EC2 console dashboard, click Launch Instance.
3. On the Choose an Amazon Machine Image (AMI) page, choose an community AMI and search `yardstick`.
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/select-amis.png)
4. Choose `yardstick-benchmark-server`.
5. On the Choose an Instance Type page, select the hardware configuration and size of the instance to launch. Recommend to choose high network performance instance types: *m3.xlarge, m3.2xlarge, c4.2xlarge, c4.xlarge*.
6. On the Configure Instance Details page choose number of instances. Add benchmark configuration properties into Advanced Details section: *GIT_REPO, AWS_ACCESS_KEY, AWS_SECRET_KEY, ES3_BUCKET(optional)*. For more information about credential see amazon documentation. http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-prop.png)
7. On the Tag Instance set value for Name tag. For example `server`.
8. On the Configure Security Group page create or choose security group which has an inbound rule for port 0-65535. For example:
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-rul.png)
9. Review and run instances.

#### Run benchmark client

1. Open the Amazon EC2 console.
2. From the Amazon EC2 console dashboard, click Launch Instance.
3. On the Choose an Amazon Machine Image (AMI) page, choose an community AMI and search `yardstick`.
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/select-amis.png)
4. Choose `yardstick-benchmark-client`.
5. On the Choose an Instance Type page, select the hardware configuration. Recommend to choose high network performance instance types: *m3.xlarge, m3.2xlarge, c4.2xlarge, c4.xlarge*.
6. On the Configure Instance Details page choose number of instances. Add benchmark configuration properties into Advanced Details section: *GIT_REPO, AWS_ACCESS_KEY, AWS_SECRET_KEY, ES3_BUCKET(optional)*. For more information about credential see amazon documentation. http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-prop.png)
7. On the Tag Instance set value for Name tag. For example `client`.
8. On the Configure Security Group page create or choose security group which has an inbound rule for port 0-65535. For example:
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-rul.png)
9. Review and run instances.  

### Amazon ec2 cli

1. Install ec2 cli tools. http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html.
2. Create VPC. http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-CreateVpc.html.
3. Create subnet for your VPC. http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-CreateSubnet.html.
4. Create security group which has an inbound rule for port 0-65535.

    `ec2-create-group group_name -d group_description -c your_vpc_id`
 
    `ec2-authorize security_id -P tcp -p 0-65535 -s 0.0.0.0/0`

5. Create AWS credential. http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html
    
#### Run benchmark servers

1. Create file with benchmark properties.

    `GIT_REPO=benchmark_repo
    AWS_ACCESS_KEY=your_access_key
    AWS_SECRET_KEY=your_secret_key`

2. Run benchmark yardstick server AMI which has `ami-da4e7fb2` image id.  

    `ec2-run-instances ami-da4e7fb2 --instance-type instance_type -k you_ -n number_instance -s your_subnet_id -g security_group_id -f property_file`
    
#### Run benchmark client

1. Create file with benchmark properties.

    `GIT_REPO=benchmark_repo
    AWS_ACCESS_KEY=your_access_key
    AWS_SECRET_KEY=your_secret_key
    ES3_BUCKET=bucket_name *optional parameter by default yardstick-benchmark*`

2. Run benchmark yardstick server AMI which has `ami-823405ea` image id.  

    `ec2-run-instances ami-823405ea --instance-type instance_type -k you_ -n 1 -s your_subnet_id -g security_group_id -f property_file`

### Benchmark execution

For monitoring benchmark execution need to connect to instances. http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html

* For accessing to execution progress need to know a container id. The following command show it.

    `sudo docker ps`

* Show logs.

    `sudo docker -f logs container_id` 
    
* Enter to docker container.

    `sudo docker exec -it container_id /bin/bash`
      
* After benchmark execution results will be uploaded to ES3 bucket (if `ES3_BUCKET` isn't set then use default bucket 'yardstick-benchmark'). If bucket contains previous results yet then driver will generate comparative charts.

* That see benchmark results directly on S3 bucket, need allow browser loading unsafe scrips.
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/brows_setting.png)

## Yardstick benchmark repositories
1. **Apache Ignite.**

    *https://github.com/apacheignite/yardstick-ignite*
    
2. **Hazelcast.**

    *https://github.com/gridgain/yardstick-hazelcast*

## Provided Benchmarks
The following benchmarks are provided:

1. Benchmarks atomic distributed cache put operation
2. Benchmarks atomic distributed cache put and get operations together
3. Benchmarks transactional distributed cache put operation
4. Benchmarks transactional distributed cache put and get operations together
5. Benchmarks distributed SQL query over cached data
6. Benchmarks distributed SQL query with simultaneous cache updates

## License
Yardstick Docker is available under [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) Open Source license.