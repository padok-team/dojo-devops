# Part 5. Cleaning (~10 mins)

**🏆 Objective:** Clean what you have deployed with a few commands !

**⚙️ Exercice 1:** Delete ingress controller in Kubernetes

Why delete only the ingress controller ? Because the ingress controller had deployed a component on AWS called Network Load Balancer. That component use virtual network interfaces and public IP.

If we try de delete the infrastructure with terraform (`destroy`) without cleaning the NLB before, some network resources won't be delete because of internal dependencies.

By delete the ingress controller, we will also delete the NLB and it will be easier to delete the rest of the infrastructure with terraform !

- [ ] In your shell, uninstall the deployment of `ingress-nginx` with helm:

```
helm uninstall -n nginx ingress-nginx
```

Easy !

---

**⚙️ Exercice 2:** Delete your infrastructure with terraform

All others components will be delete by terraform (or deleted while deleting underlying ressources like EKS).

- [ ] Go to the `02-InfrastructureAsCode/` directory
- [ ] Use the `destroy` command for terraform
- [ ] Terraform will show how many resources will be deleted
- [ ] Confirm and wait a few minutes

All your infrastructure is gone 🪦

Easy to deploy, easy to destroy. That's why IaC is so powerfull.

```
 _____  _     _____   _____ _      ____ 
/__ __\/ \ /|/  __/  /  __// \  /|/  _ \
  / \  | |_|||  \    |  \  | |\ ||| | \|
  | |  | | |||  /_   |  /_ | | \||| |_/|
  \_/  \_/ \|\____\  \____\\_/  \|\____/
```
