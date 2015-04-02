# Yardstick Docker
Yardstick Docker is a set of docker images which contains benchmarks written on top of Yardstick framework.

## Yardstick Framework
Visit <a href="https://github.com/gridgain/yardstick" target="_blank">Yardstick Repository</a> for detailed information
on how to run Yardstick benchmarks and how to generate graphs.

## Running Benchmarks
1. Pull latest docker image for server.
    
    docker pull yardstickbenchmarks/yardstick-server

2. Run container from server image.

    docker run -it --net=host -e GIT_REPO=*url repo* yardstickbenchmarks/yardstick-server
    
    where GIT_REPO mandatory argument and GIT_BRANCH is optional. GIT REPO is url to yardstick benchmark project.

3. Pull latest docker image for client.

    docker pull yardstickbenchmarks/yardstick-client

4. Run container from client image.

    docker run -it --net=host -e GIT_REPO=*url repo* -e GIT_BRANCH=*git branch* -v *dir*:/mnt yardstickbenchmarks/yardstick-client
    
    where dir is absolute path to folder where will be uploaded results.

## Running Benchmarks in AWS
The easiest way to run benchmarks in AWS is an using created AMI image.

1. Open the Amazon EC2 console.
2. From the Amazon EC2 console dashboard, click Launch Instance.
3. On the Choose an Amazon Machine Image (AMI) page, choose an community AMI and search *yardstick*.
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/select-amis.png)
4. Choose *yardstick-benchmark-server*.
5. On the Choose an Instance Type page, select the hardware configuration and size of the instance to launch. Recommend to choose *c4.4xlarge, c4.2xlarge, c4.xlarge* of instance types.
6. On the Configure Instance Details page choose number of instances. Add benchmark configuration properties into Advanced Details section: *GIT_REPO, AWS_ACCESS_KEY, AWS_SECRET_KEY, ES3_BUCKET(optional)*. For more information about credential [see.](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-prop.png)
7. On the Configure Security Group page create or choose security group which has an inbound rule for port 0-65535. For example:
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-rul.png)
8. Review and run instances.
9. Launch benchmark client instance by doing followed steps: first steps as 2-3, then choose *yardstick-benchmark-client* AMI, then as 5-8.
9. Connect to instance. For more information [see.](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html)
10. Looking at progress by *sudo docker logs container_id* command.  

After benchmark execution results will be uploaded to ES3 bucket. If bucket contains previous results yet then driver will generate comparative charts.

![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-result.png)
![alt AMI](https://raw.githubusercontent.com/yardstick-benchmarks/yardstick-docker/master/img/bench-results.png)

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