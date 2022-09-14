# Part 4. Applicatin (~30 mins)

[Go to part 4](./Part-4.md)


The code for the application is available in the `04-Application` directory. The directory contains:

  - a simple Golang application that provide an HTTP endpoint.
  - a file `.gitlab-ci.yml` file that will instruct Gitlab about the stage and the job that we want to build and deploy our application.
  - an simple Helm chart to deploy our application on Kubernetes

**🏆 Objective:**  In this part we will build and deploy our application with Gitlab & Gitlab CI

**⚙️ Exercice 1:** Build our application with Gitlab CI



- [ ] Clone this project [demo-kubernetes](https://github.com/padok-team/demo-kubernetes) inside `04-Appliaction/` directory
- [ ] Optional: if you have the time (and Docker installed on your laptop) you can build the image locally with `docker build -t demo-k8s:latest .`
- [ ] Optional : test the container `docker run -it -p 8080:8080 demo-k8s` and use `curl` to request the API
- [ ] 


<details>
<summary>Hint 2</summary>
To clone the repo

```
git clone git@github.com:padok-team/demo-kubernetes.git
```
</details>
