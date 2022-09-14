# Part 1. Amazon Web Service (~5 mins)

Amazon Web Service (AWS) offers cloud service to deploy your workload. A workload can be everything from a simple static website, to an ecommerce website and a data pipeline to analyse weather data. Cloud Service Provider like AWS (and others : Google with GCP & Microsoft with Azure) offers a lot of "managed services" like Compute, Networking, Storage for the simplest and Kubernetes, Kafka or Postgresql for advanced service. AWS provide hundred of managed services but we will use a few o them for the Dojo.

Don't worry if you don't know AWS or the service that we will use. Everything is explain and a solution is provided each time. Don't forget to ask the staff if you have any question, any time !

**🏆 Objective:** Get your credential and test your access

**⚙️ Exercice 1 :**

- [ ] If you don't have already install the **[AWS CLI, it's time to do it](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)**
- [ ] You have received an email with an invitation to a dedicaced AWS Account specially created for the Dojo
- [ ] Use the provided URL to setup your account. You need to set your password
- [ ] Verify that your are on the Paris region (top right of the AWS console)
- [ ] Once connected, click on your name on the top right menu and select **[Security Credentials](https://us-east-1.console.aws.amazon.com/iam/home?region=eu-west-3#/security_credentials)**
- [ ] Next, in the section "Access keys for CLI, SDK, & API access" click on "Create access Key"
- [ ] Your Access key is created, now you need to record it on your machine
- [ ] Open your shell and create a directory `.aws` at the root of your home directory
- [ ] Create a file `credentials` inside this directory and copy the following content with the values from the AWS console

```
[default]
aws_access_key_id=AKIAxxxxxx
aws_secret_access_key=xxxxxx
```

- [ ] Create a file `config` inside the same directory and copy the following content 

```
[default]
region=eu-west-3
output=json
```

- [ ] Now you can test your access to AWS

```
aws sts get-caller-identity
```

The command will output something link this 

```
{
    "UserId": "AIxxxxxxx",
    "Account": "xxxxx",
    "Arn": "arn:aws:iam::xxxxxxx:user/guillaumel"
}
```

If it's ok, go to the next part, otherwize, ask for help 🙌