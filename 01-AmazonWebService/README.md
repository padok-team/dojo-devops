# Part 1. Amazon Web Service (~5 mins)

Amazon Web Services (AWS) offers cloud services to deploy your workloads. A workload can be everything from a simple static website, to an e-commerce website and a data pipeline to analyse weather data. Cloud Services Providers like AWS (and others: Google with GCP & Microsoft with Azure) offer a lot of "managed services" like Compute, Networking, Storage for the simplest and Kubernetes, Kafka or Postgresql for advanced services. AWS provides hundreds of managed services but we will use a few of them for the Dojo.

Don't worry if you don't know AWS or the service that we will use. Everything is explained and a solution is provided every time. Don't forget to ask the staff if you have any question, at any time!

**🏆 Objective:** Get your credentials and test your access

**⚙️ Exercise 1 :**

- [ ] If you don't have already, install the **[AWS CLI, it's time to do it](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)**
- [ ] You have received an email with an invitation to a dedicaced AWS Account specially created for the Dojo
- [ ] Use the provided URL to setup your account. You need to set your password
- [ ] Verify that your are on the Paris region (top right of the AWS console)
- [ ] Once connected, click on your name on the top right menu and select **[Security Credentials](https://us-east-1.console.aws.amazon.com/iam/home?region=eu-west-3#/security_credentials)**
- [ ] Next, in the section "Access keys for CLI, SDK, & API access" click on "Create access Key"
- [ ] Your Access key is created, now you need to record it on your machine
- There is two methods
    - [ ] **Method 1:** Let yourself be guided by `aws configure` command
    - [ ] **Method 2:** Copy the values and create the file manually

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

The command will output something like this:

```
{
    "UserId": "AIxxxxxxx",
    "Account": "xxxxx",
    "Arn": "arn:aws:iam::xxxxxxx:user/guillaumel"
}
```

If it's ok, go to the next part, otherwize, ask for help 🙌
