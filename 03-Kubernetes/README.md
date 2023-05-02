# Part 3. Kubernetes (~15 mins)

> Kubernetes is an open-source container orchestration system for automating software deployment, scaling, and management.[4][5] Google originally designed Kubernetes, but the Cloud Native Computing Foundation now maintains the project.

From [Wikipedia](https://en.wikipedia.org/wiki/Kubernetes)

**🏆 Objective:**  In this part we will deploy some applications on our Kubernetes cluster previously deployed. This applications will allow to deploy our application (Gitlab Runner), scale (horizontally) our application (cluter-autoscaler) and reach our application from outside (ingress-nginx).

**⚙️ Exercice 1:** Deploy cluster autoscaler

- Cluster autoscaler is a Kubernetes service dedicated to detect new node requirement. It uses the data from the cluster (through the API Server) to ensure that each pod scheduled has the sufficient ressources to run, otherwise it will add new nodes (except if you reach the maximum number of node of our node group)
- We will use Helm to deploy cluster-autoscaler. Helm is a popular tool in Kubernetes ecosystem that allow us to use _Chart_ (a directory with YAML file using go templating) to deploy application on Kubernetes
- Chart can be store localy or remotely. When used from a remote source, a `values.yml` file is used to set custom parameter for our needs
- Helm TL;DR => generate yaml file, using Go templating functions, to apply manifest on Kubernetes to deploy an application 

- [ ] If you don't have already install **[Helm, it's time to do it](https://helm.sh/docs/intro/install/)**

- We are doing to deploy our first component on Kubernetes : `cluster-autoscaler`. It will be used to scale the number of nodes regarding the needs of pods.
- We need to configure a little bit cluster-autoscaler beforing deploying it

- [ ] Edit the file `cluster-autoscaler/values.yaml` and set your cluster name for `clusterName` parameter (you can get it with `terraform output`).
- [ ] In the same file, set the value for `eks.amazonaws.com/role-arn` parameter. You can get the value with `terraform output`
- [ ] Then, deploy cluster-autoscaler on your cluster : `helm upgrade --install cluster-autoscaler cluster-autoscaler -n cluster-autoscaler --create-namespace=true`
- [ ] Once finished, check your deployment status with `kubectl`. Don't forget that resources are deployed in namespaces !
- [ ] For the Gitlab runner, edit the file `gitlab-runner/values.yaml` and replace the value for `runnerRegistrationToken`. To get a token, go to your `Gitlab Repository > Settings > CI/CD > Runner >  Specific runners` and copy the token.
- [ ] Also, change the value for `eks.amazonaws.com/role-arn` like for `cluster-autoscaler`
- [ ] Then, install `gitlab-runner`
- [ ] Process in the same way for `ingress-nginx` (no configuration is needed)
- [ ] Check the status of your new deployments
- [ ] Last, deploy a component to get metrics (monitoring) for our pods:

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Our infrastructure is fully deployed. Lets go to the application part.

Note that if you go to your Gitlab repository, in `Gitlab Repository > Settings > CI/CD > Runner >  Specific runners` you will see that a runner is active.

<details>
<summary>Hint 1</summary>
Helm `upgrade` command with `--install` parameter is the recommended way to deploy an application with Helm. If the application is deployed or new on the cluster, you change will be applied.
</details>

<details>
<summary>Hint 2</summary>
You can check the status of a deployment with:

```
kubectl get pod -A
kubectl get deployment -A
kubectl get pod -n cluster-autoscaler # to check pods deployed in cluster-autoscaler namespace
```

Don't forget to specify the namespace (or to change the current namespace):

```
kubectl -n kube-system get pod
kubectl config set-context --current --namespace <NAMESPACE>
```
</details>

<details>
<summary>Hint 2</summary>
To view the log of your pod

```
kubectl get pod # get a pod name
kubectl logs <POD_NAME>
kubectl logs -f <POD_NAME> # to 'follow' the log stream
kubectl logs -f <POD_NAME> --tail 100 # start log stream on the last 100 lines
```
</details>

<details>
<summary>Hint 2</summary>
To deploy Gitlab runner and Nginx Ingress

```
helm upgrade --install gitlab-runner gitlab-runner -n gitlab --create-namespace=true
helm upgrade --install ingress-nginx ingress-nginx -n ingress-nginx --create-namespace=true
```
</details>
