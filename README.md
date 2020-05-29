# The Swiss Army Knife for Developing Cloud Native Applications - Rio Cloud Conference Day

A demo to show how sync local [Quarkus](https://quarkus.io/) sources with pod running in kubernetes and use the `quarkus:dev` mode to hot reload the changes, we're using Vagrant, Microk8s, Tilt and Quarkus. During the environment provisioning we're starting Postgresql, Prometheus and Grafana (all of them are helm packages). It was built for a presentation done in [Rio Cloud Conference Day](http://cloudconferenceday.rio/) with topic `The Swiss Army Knife for Developing Cloud Native Applications`.

Here is a summary of what is being done here (note that we have health checks properly setup). That's why first build takes more time.

![](/home/bandrade/Downloads/repo/doc_images/app.gif)

Make a change at the code and see the magic happening:

![](/home/bandrade/Downloads/repo/doc_images/refresh.gif)



## Important

This Dockerfile is used for development purposes, in order to have a production image, you may consider to use [Native builds](https://quarkus.io/guides/building-native-image)

## Pre-requiste

- Have Docker or Buildah properly installed.
- Have Vagrant installed with vagrant-ssh plugin.
- Have Virtual box or Libvirt installed to create VMs.

## Running the demo

Clone the demo sources locally:

```sh
https://github.com/bandrade/rio-cloud-conference-day.git
cd rio-cloud-conference-day/infra
```

Start the provisioning with the following command:

```sh
vagrant up
```

Waiting until the provisioning is done:

```sh
==> default: Setting hostname...
==> default: Automatic installation for Landrush IP not enabled
==> default: Installing SSHFS client...
==> default: Mounting SSHFS shared folder...
==> default: Mounting folder via SSHFS: /home/bandrade/Downloads/repo/infra => /home/vagrant/scripts
==> default: Checking Mount..
==> default: Checking Mount..
==> default: Folder Successfully Mounted!
==> default: Running provisioner: ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.9.9).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    default: Running ansible-playbook...

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [default]

TASK [microk8s : check if this is really ubuntu] *******************************
skipping: [default]

TASK [microk8s : setting noninteractive mode] **********************************
changed: [default]

TASK [microk8s : install snap] *************************************************
ok: [default]

TASK [microk8s : check is ufw installed] ***************************************
changed: [default]

TASK [microk8s : disabling ufw] ************************************************
changed: [default]

TASK [microk8s : install microk8s] *********************************************
changed: [default]

TASK [microk8s : microk8s status] **********************************************
changed: [default]

TASK [microk8s : enable dns] ***************************************************
changed: [default]

TASK [microk8s : enable ingress] ***********************************************
changed: [default]

TASK [microk8s : enable registry] **********************************************
changed: [default]

TASK [microk8s : enable storage] ***********************************************
changed: [default]

TASK [microk8s : create kube dir] **********************************************
ok: [default]

TASK [microk8s : configure kubeconfig] *****************************************
changed: [default]

TASK [microk8s : configure snap alias] *****************************************
changed: [default]

TASK [microk8s : configure vagrant user] ***************************************
changed: [default]

PLAY RECAP *********************************************************************
default                    : ok=15   changed=12   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0 
```

Export the `KUBECONFIG` environment variable and ensure that all pods are in `Running` state:

```sh
export KUBECONFIG=$(pwd)/.kube/kubeconfig
kubectl get pods --all-namespaces
NAMESPACE            NAME                                      READY   STATUS    RESTARTS   AGE
container-registry   registry-7cf58dcdcc-g8fc2                 1/1     Running   0          7m56s
ingress              nginx-ingress-microk8s-controller-kp2pm   1/1     Running   0          7m47s
kube-system          coredns-588fd544bf-s4j5n                  1/1     Running   0          8m6s
kube-system          hostpath-provisioner-75fdc8fccd-dcdc6     1/1     Running   0          7m55s
```

Now go to the `app` directory:

```sh
cd ../app
```

If it's being used docker as builder, start the environment with:

```sh
tilt up
```

If it's being used buildah as builder, start the environment with:

```sh
tilt up -f Tiltfile.buildah
```

The command creates the following resources:

- a prometheus deployment
- a grafana deployment with some dashboards being imported
- a postgresql deployment
- a kubernetes deployment called **quarkus-todo-demo**
- a persistence volume claim called `m2-cache` to cache the maven artifacts for faster builds

Check the stats of the application:

```
kubectl get pods -w ##(1)
```

1. A successful start will have **quarkus-todo-demo** in **Running** status

| Note | You can terminate the `kubectl get pods -w` using the command CTRL+C |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

You can now make changes to the sources e.g change Sort by to `title` in TodoResource.java 

After few seconds you will see your TODO itens being ordered by name.

## Cleanup

```
tilt down -f <Tiltfile>
```
