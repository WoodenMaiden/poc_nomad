# Nomad Poc

A simple POC to test Nomad and Consul, for AgroLD.

## Requirements

- [Vagrant](https://developer.hashicorp.com/vagrant)
- [Ansible](https://www.ansible.com/)
- libvirt or VirtualBox

To install the nomad installation role run the following command:

```bash
ansible-galaxy install brianshumate.nomad
```

## Launch the POC

```bash
vagrant up

# To destroy the VMs
vargrant destroy
```

> [!NOTE]
> You might need to give root password, especially if you are using libvirt. To avoid this, you can add your user to the `libvirt` group.

## Errors that can occur
If you have an error like this 

```
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

mount -o vers=4 192.168.121.1:/home/yann/Documents/sources/ird/poc_nomad /vagrant

Stdout from the command:

Stderr from the command:

mount: /vagrant: bad option; for several filesystems (e.g. nfs, cifs) you might need a /sbin/mount.<type> helper program.
```

Try solution given by [this link](https://ostechnix.com/vagrant-up-hangs-when-mounting-nfs-shared-folders-how-to-fix/)

netaddr module may not installed by default, you need to install it with pip3

```
pip3 install netaddr
```