# nitro-build


This repo is all about running TEA Node in AWS Nitro.


AWS Nitro runs on an AWS C5.xlarge or other larger instances.

Enclave is a isolated hardware-protected virtual machine inside its parent instance. 

Tea-runtime is running inside the enclave. It can communicate with outside world using vsock only.

Parent-instance-client is running inside a docker container outside of the enclave. 

VMH-server is the service that relay all message between parent-instance-client and tea-runtime. 

On one hand, vmh-server communicate with tea-runtime inside the enclave via vsock, on the other hand, vmh-server communicate with parent-instance-client that running inside the docker container via tcp.



## Aws EC2 Environment prepare
create an Aws EC2 instance, choose the c5.xlarge host type and enable the Enclave option, please see [here](https://github.com/tearust/research/blob/main/aws/nitro/nitro%E7%8E%AF%E5%A2%83%E5%87%86%E5%A4%87.md) to get more details

Once the EC2 instance is created and running. ssh into the EC2 instance

### Install git and git large file service (git-lfs)
```
sudo yum install -y git
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel
sudo yum install -y git-lfs
```

### clone nitro-build repo

```
git clone https://github.com/tearust/nitro-build
```

Once done, enter the code repo by `cd nitro-build`

### Init aws nitro environment

run 
```
./aws-prepare.sh
```

press Ctrl+D to quit ssh connection to apply those configuration settings take effect.

### Use tnux for multiple shell running

ssh into the EC2 instance again. This time, all config should take effect.

tmux can help you handle the multiple shells in the following steps.

run `tmux` or `tmux a` if you already have a tmux session

### initialize enclave environment

```

sudo ./enclave-init.sh

```
this is required at the first time you run the test, after that you shall skip this step.

### build enclave image

```
./enclave.sh docker 
```
to build enclave image from docker hub image: tearust/runtime:nitro
### start enclave and tea-runtime

run 
```
./enclave.sh debug 
```
to run enclave image in debug mode, then you should the an enclave id, copy this enclave for the next step

### Check enclave status and id

Run `./enclave.sh list` anytime you want to make sure if there is an enclave running

After running the enclave app, you should following the next step to run client app on the parent instance side:

### start vmh-server

run

```
./vmh-server
```

### start aprent-instance-client

press Ctrl+B + C to create a new tmux tab page or Ctrl+B + N to switch to the client app tab page if you already have one

```
chmod +x ./parent-client.sh
./parent-client.sh
```

Now, you should see the promopt again. This promopt is the docker container's prompt. That means you are inside the docker container now.

You can run provider_kvp or parent-instance-client for testing. You can also switch between two tmux session by press `ctrl+b n` to check logs. Make sure all three programs running ok.
