# Part 5. Play with Kubernetes (~10 mins)

**🏆 Objective:** A Quick overview of how powerfull Kubernetes is by playing with high availability and autoscaling

**⚙️ Exercice 1:** Pod autohealing

Autohealing means that in case of a failure, something will automatically handle the situation and "health" the system. In our case, Kubernetes will handle pod failure and restart or launch a new one based on the configuration set (the number of replica).

For now our deployment had only 1 replica.

To simulate a crash, there is a route in our API that will "crash" (exit 1) the pod. In that case, Kube will restart the container (not the pod !)

- [ ] Get your pod name
- [ ] Watch the log of your pod with `kubectl logs <POD_NAME> -f`
- [ ] In antoher shell, use `curl` to call the `/panic` route of your api
- [ ] In the first shell, you will see that the pod terminated
- [ ] Check running pod at see that your pod is available again
- [ ] Look at the `RESTARTS` counter, it is not at `1` (the container has been restarted)
- [ ] You can curl your API (no the `/panic`) to see that the application is fully available

Kube will handle other simular situation, like Out Of Memory for example, in the same way

- [ ] You can also delete your pod to see what happens
- [ ] Kube will automatically start a new pod de replace the old one

<details>
<summary>Hint 1</summary>
To delete a pod :
```
kubectl delete pod <POD_NAME>
```
</details>

---

**⚙️ Exercice 2:** Pod autoscaling

Autoscaling mean that your system will scale (grow) automatically based on some events or metrics. Usually we use CPU usage for scaling but memory, tcp connection or other system metrics could be use.
Sometimes, applications metrics could alos be use, like the number of message waiting in a queue.
Autoscaling will help your applications to handle the load under all scenario while when no resources are needed (for example during the nigh), the system will use less resources and will cost less.

To simulate a heavy load on our application, we will use `vegeta` tools to send thousand of requets to overload the current pod and force Kube to start other pod.

The systeme responsible of scaling the pod (horizontally) is named [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) for **H**orizontal **P**od **A**utoscaling.

- [ ] Get the HPA information for the application
- [ ] Get the current usage of CPU and memory for your running pod
- [ ] As you can see, a few CPU and memory are used and your are below the limit to start a new pod from the HPA

Since the default route of our application doesn't consome too much CPU even under high load, there is another root that use more CPU for each request avaiable: `/load`. Calling this endpoint at high frequency will consomme a lot of CPU that will help to trigger the HPA

- [ ] We will use `vegata` to overload our API. Create a file `targets.txt` like the example below:

```
GET http://<YOUR_PUBLIC_ENDPOINT>/panic
```

- `vegeta` is a load testing tool useful to stress application.

- [ ] Use `vegeta` like in the example below to overload your application:

```
vegeta attack -rate=15/s -targets target > /dev/null
```

- [ ] Watch the CPU use of your current pod. After a few seconds, you will see that the number increase (almost `1000Mi`)
- [ ] Also watch the status of your HPA. After a few seconds, you will see that the current usage will go over the limit we have fixed (70%). This will trigger the launch of new pods
- [ ] After a few seconds/minutes, you will see more pods appearing
- [ ] HPA will adjuste the number of pod while the mean of CPU usage of all pod is above the limits

It's a very simple example but it shows you the basics of HPA. It's a powerfull feature that will help you to automatically ajust the size of your application regarding the load. Combined with `cluster-autoscaler` you are certain to be able to handle your business in almost all situations.

- [ ] Use `kubectl` to show your nodes
- [ ] You will see that some nodes are recents: `cluster-autoscaler` has started new node because there is not enough resources available to start new pod ("launched" by the HPA)

And ... that's all ! We hope you enjoy the exercices and we learnt a few things during this Dojo.

Go tho the last part to clean all the resources you have deployed.

<details>
<summary>Hint 1</summary>
Get HPA and CPU/Memory information for a pod :
```
kubectl get hpa
kubectl top pod
```
</details>
