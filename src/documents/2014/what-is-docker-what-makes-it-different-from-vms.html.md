---
title: "What is Docker? What Makes It Different From VMs?"
layout: "post"
isPost: true
date: "06-12-2014"
headline: "machine4.png"
urls:
   - /2014/what-is-docker-what-makes-it-different-from-vms
tags:
   - generation
   - docker
   - container
   - linux
   - virtualization
   - automation
   - devops
   - development
---

# What is Docker and What Makes It Different From VMs?

## PAAS will be a really big in the near future. Considering the automation of the infrastructure and whole devops movement, I believe Docker stands a great chance.

**Docker** team has recently released product's first public **version**. They are really doing a great job, and it seems like the adoption trend compare to alternative infrastructure automation tools like **Puppet**, **Chef** and **Ansible** so far has been nothing but a great success.

Technically speaking, Docker is using a totally different approach to the whole IT infrastructure automation. Instead of leveraging the VM approach, they are taking the container approach where you can actually get very close to the bare metal. Before diving into the Docker world, I believe it would be beneficial to give a little bit of a history on the technology that Docker uses.

### Brief History

I believe first Linux container was **Open VZ**. I guess the team is currently still the biggest contributor to the LXC kernel. The main idea was to patch the kernel and allow the architecture and devices to be used in many servers hosted in the same box. Later on FreeBSD team came up with the idea of **Jails**. Very similar idea was used. Basically they were putting apps and services into things (container) called Jails by using **chroot** concept.

Commercial Unix world also implemented their own versions of containers. AIX, Solaris and so on.

Later on, **LXC** project kicked in and now Linux kernel supports LXC since *2.6.26/3.8.0*. These are all good, but what is a container? Well, keep reading.

### What is a Container?

Container is basically the new fancy term around **Operating System-Level Virtualization**. The idea is creating isolated user space instances instead of just one. In other words, sharing the hardware and making it available for many operators on the kernel itself rather than another layer like **ESX, Hyper-V** kinda software. These user space instances are often called VPS (Virtual Private Servers) or VE (Virtualization Engine). Keep in mind that Docker is not the only one doing this. There are many projects around the same concept.

Let's think about the virtualization for a second here. The way full virtualization works is roughly creating a full copy of the operating system that runs on a virtual hardware space. Meaning, virtualization software is responsible from all the data exchange, layer separation and the security. Running multiple of these VMs on the same box also requires a lot of resources since every single VM will be a full copy of the operating system itself. It's even a common practice in the industry to install small footprints like RHEL 6 minimal to achieve fast provisioning.

On the other hand, containers can provide:

* Speed - *instead of minutes, it's probably 2-3 seconds*
* Soft Memory - *allocating applications in memory rather than disks*
* Minimal Footprint - *instead of thousands of MBs, it's tens of MBs*
* Can Run Many - *like literally 100 containers could be run in parallel on a single box*
* Resilience - *when you have a crash, you can relaunch immediately*
* Security - *if one container gets DDOS kinda attack, others won't get effected*
* Snapshots - *using union file-systems*

As you can see, there are great benefits of using a container rather than a VM.

### What is Docker?

You can think of Docker as a container manager for \*-nix based operating systems. It's written in Google's **Go** language and using Linux kernel's **cgroup** and namespace technology in addition to LXC and **AUFS** for union file system.

So basically it allows you to create many isolated environments over a single \*-nix kernel as shown in the below diagram. Docker daemon will detach your processes from a specific layer of the kernel and assign them to a new one. Therefore, those specific processes can live in a *Virtual OS* with a new group of PIDs, a new set of users, a completely unshared IPC system (mutexes, semaphores, shared memories, unix domain sockets, etc), a dedicated network interface and its own hostname.

![Kernel Diagram](/images/articles/linux-kernel-chgroups-arch.png "Linux kernel unified hierarchy and systemd")

Docker has 3 components: *Docker Daemon*, *Docker Images* and *Docker Repositories*. Docker Daemon runs as root and basically orchestrates all the containers. Docker Images are virtual OS images and technically they have way less footprint than the actual OS images. Due to the *AUFS* filesystem, all the committed writes to the filesystem are stacked, therefore can be unified to the last revision any point in time. Kinda like snapshots in the VM world, only better (like a VCS). Due to the nature of the filesystem all these write operations are also cacheable. Meaning, if Docker finds out that you don't have any changes up to a certain revision, it plays everything up to that particular revision from the cache and rest by applying the writes. This gives a huge performance benefits on provisioning time. On top of all these benefits, images can also be exchanged with other folks. Last component of Docker ecosystem is repositories. All this is that the images you have has to be stored somewhere whether it is private or public. Docker provides a public repository for everyone, however it is super easy to build your private repo as well.

There are plenty of tutorials on Docker usage. I actually intended to skip it, however I'm planning to create another article on how to make use of Docker for your development process with some real-world examples. Stay tuned...

1. http://www.docker.io/
1. http://blog.docker.com/2014/06/its-here-docker-1-0/
1. http://puppetlabs.com/
1. http://www.getchef.com/
1. http://www.ansible.com/
1. http://openvz.org/
1. http://www.freebsd.org/doc/handbook/jails.html
1. http://en.wikipedia.org/wiki/Chroot
1. http://en.wikipedia.org/wiki/LXC
1. http://en.wikipedia.org/wiki/Operating_system%E2%80%93level_virtualization
1. http://en.wikipedia.org/wiki/Full_virtualization
1. http://golang.org/
1. http://en.wikipedia.org/wiki/Cgroups
1. http://aufs.sourceforge.net/
