# vagrant-microk8s

Vagrant machine running [MicroK8s](https://microk8s.io/).

Install prerequisites:

    brew cask install vagrant virtualbox virtualbox-extension-pack

Tweak CPU and memory in `Vagrantfile`.

Tweak plugins in `provision.sh`.

Start the VM:

    vagrant up

Show Kubernetes version:

    ./m kubectl version

Show Istio version:

    ./m istioctl version

Show images in private registry:

    ./m docker images

Optional: Create aliases to avoid prefixing `kubectl` with `./m`:

    source alias.sh

Remove aliases created by `source alias.sh`:

    source unalias.sh

Optional: Set environment variables to use `kubectl` on the host:

    source acticate.sh

Unset environment variables configured by `source activate.sh`:

    source deactivate.sh

Stop the VM:

    vagrant halt

Destroy the VM:

    vagrant destroy -f
