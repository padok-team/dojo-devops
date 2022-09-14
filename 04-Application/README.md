# Part 4. Applicatin (~30 mins)

The code for the application is available in the `04-Application` directory.

The directory contains:

- a simple Golang application that provide an HTTP endpoint
- a file `.gitlab-ci.yml` file that will instruct Gitlab about the stage and the job that we want to build and deploy our application
- an simple Helm chart to deploy our application on Kubernetes

**🏆 Objective:**  In this part we will build and deploy our application with Gitlab & Gitlab CI

**⚙️ Exercice 1:** Build and deploy our application with Gitlab CI

- [ ] Edit the file `chart/values.yaml` and change the value for `containers.image.repository`: use a correct value instead of `FIX_ME` (it's the name your choose in part 2 for ECR repository)
- [ ] Commit the content of your directory to your Gitlab repository (created in Part-0) (follow the instruction `Push an existing folder` from Gitlab.com)
- [ ] Go to your project on Gitlab.com and go to the `CI / CD > Pipelines` section
- [ ] A pipeline should be runnning since you pushed a valide `.gitlab-ci.yml` file
- [ ] You can check the logs of a job by clicking on it
- [ ] Take a look at the operation running in each job
- [ ] The 2 jobs should finish with a `success` status (green)

A few explications:

- there are 2 stages defined:

```
stages:
  - build
  - deploy
```

A stage is like a step that contain 1 or more jobs (actions).

Stage are "executed" in the order that they are definied. Once all the job in the stage are finished and in a success state (or warning), Gitlab will process the jobs of the next stage.

- there are 2 jobs, 1 in each stage

```
build:
  stage: build
[...]

deploy:
  stage: deploy
[...]
```

Each job contains a `script` section that define all the operation that we want in the job. It's like all the command that you will execute in your shell to build and deploy the application.

Job within the same stage are launched simultaneously.

Possibly you can start job early on a stage with a special instruction: `needs: []`. But isn't usefull in our case.

- each job use an image since we are use a Kubernetes executor for Gitlab job. So we need to specify the image to use to run the job. Our image should contains all the binaries needed for our job.

- [ ] Thanks to Gitlab and the runner we have deployed in our cluster, the application is deployed !
- [ ] Use kubectl to check the status of your deployment. Don't forget that most of the ressources in Kubernetes are namespaced.

A few explications :

Our deployment (the YAML generated with helm from our Chart) had deployed a few ressources in the cluster in addition of the kube deployment resource:
 
- A `service` resource that give a uniq entrypoint for the request to our pod(s)
- A `ingress` resource that will allow our application to be reachable from outside the cluster
- A `hpa` resource that will instruct Kubernetes how to scale the application when needed

We will look later at the `hpa` resources.

- [ ] Take a quick look at the resources above with kubectl
- [ ] The `ingress` resource has show you an public endpoint. You can use it to reach your application.
- [ ] Use curl to query your application, you shoud see a message like this

```
Version: 1663174978
Kubernetes:
  Namespace: demo
  Node:      ip-10-1-6-130.eu-west-3.compute.internal
  Pod:       demo-k8s-7885f77f67-g9mrb
```

Our application is deployed and reachable from outside ! Let's go the last part to play a little bit with Kube.

<details>
<summary>Hint 1</summary>
Get the status of your deployment:

```
kubectl get pod -n demo
```
</details>

<details>
<summary>Hint 2</summary>
Get `service`, `ingress` and `hpa` resource status:

```
kubectl get service -n demo
kubectl describe service demo-k8s -n demo
kubectl get ingress -n demo
kubectl get hpa -n demo
```
</details>