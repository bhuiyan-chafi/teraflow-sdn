# Can I emulate ONOS - Mininet in my MAC?

Well, the answer is not concrete. We will discuss why and how! So, let's start. Let me give my MAC's description first:

## About my MAC

- MAC Air M2
- OS Sequoia 15.6
- Memory 8GB
- We all know MAC air doesn't come with a cooling fan inside. (One answer for being no!)

Now I want to explain the procedures I followed and the outcomes. I have tested several options like: VirtualBox with the .ova file from the professor,VirtualBox with a fresh linux distro, QEMU through UTM, Dockerization, etc. I wouldn't say it's impossible to make it work because there was one thing I couldn't test because I don't have a Macbook pro. Maybe that's the only ray of hope we have left, but we can't guarantee that the mac users will be mac pro users, fact! So, let's start.

## Importing the LAB_SDN_.... file in Oracle VirtualBox

Maybe you will think that a different version of Oracle VirtualBox might work! But the problem is not with the Oracle VirtualBox, but the your MAC cpu architecture. Our MAC CPU architecture is not x86_64, it is arm64. This architecture actually ruins everything. So, start importing the file:

- download the file, it should be 21.8GB after successful download.

`Few students with x86_64(any machine except mac) CPUs will face difficulties importing the file as well. Most of the time the issue is with the file. The file is very large. If your internet is not stable it will drop and show that it has been downloaded successfully, but it's not. In that case while importing you will face errors. Try to copy the file from someone using an external HDD or download it from a stable connection.`

- import the file in your VirtualBox(I have tested mine with 7.1.6). After importing successfully, look at the logo on the left. On top-left corner of the logo you will see `x86` icon, and this is the nightmare.

As we all know that VM runs on top our machine's hardware, it requires same CPU architecture that the guest OS is written on. So, the linux distro that we have in the OVA file is a typical linux distro that is specified for x86 architecture not `arm64`. You can read more in this [forum-link](https://discussions.apple.com/thread/255893576?sortBy=rank).

## Importing the file in QEMU(UTM)

Typically QEMU doesn't support `.ova` file, so you have to convert your `.ova` file into `.qcow2`. Follow [these steps](https://sysadmin102.com/2024/01/utm-converting-vdivirtualbox-raw-vmdkvmware-image-to-qemu-image-qcow2/) to convert your file. Once you have successfully converted your file:

- [Download UTM](https://mac.getutm.app), and install it.
- Select Emulate and import your `.qcow2` file.

**My Output**: For me I was able to import it. After that I waited 20 minutes for the login screen. After logging in there was a black window for 40 minutes!!! Even if it would have worked, there was no way we could have used for our network simulation. You can read this [reddit-discussion](https://www.reddit.com/r/MacOS/comments/1jmy4ni/is_utm_broken_and_extremelly_slow_unusable_for/) why it happens(this CPU architecture again, lol!).

**So the answer is no, again!**

## Creating a new VM and install everything that our course requires

In this step, I tried installing a fresh linux distro (ubuntu-server-24.04 then transform it into ubuntu-desktop-24.04) and then setting it up for our course. Since linux doesn't have any desktop image for arm64 architecture, we have to install the server image and then convert it into a desktop image. This process is really easy and you can give it a try, if you want(for other purposes).

- download [ubuntu-live-server-arm64](https://ubuntu.com/download/server/arm).
- create a virtual machine and install it.
- transform it into ubuntu desktop.

You can follow this [turotial-video](https://www.youtube.com/watch?v=LjL_N0OZxvY&pp=ygUjdWJ1bnR1IGxpdmVyIHNlcnZlciBhcm0gdmlydHVhbCBib3g%3D), if you need help for the installation. It will guide through every process till transformation into a desktop-image.

### Installation of ONOS and Mininet

We will follow the steps our professor mentioned in his environment setup video tutorial. It includes installation of: openjdk, bazel, onos, mininet, etc.

#### Starting with BAZEL

`ONOS` requires a specific version of `bazel` as mentioned in the tutorial. It was really hard to find an `arm64` version of that file, but they actually have in in their [archive-library](https://github.com/bazelbuild/bazel/releases/tag/6.0.0)(phew!).

So, I installed `BAZEL` but then got disappointed. Because when you will install `ONOS` using the command `ok clean`, it will download dependencies through `bazel` and some of these dependencies doesn't have `arm64`binary files. **Again the CPU architecture**!

![library-error-1](./issues/WhatsApp%20Image%202025-09-07%20at%2011.33.03.jpeg)

![library-error-2](./issues/WhatsApp%20Image%202025-09-07%20at%2011.33.19.jpeg)

And another major issue for MAC Air Users is the extreme heating of your machine. After 10 minutes your will machine will start making a specific sound to shutdown the VM. If you are facing a sound like this, [shut-it-down](./issues/WhatsApp%20Video%202025-09-07%20at%2011.33.23.mp4) right now.

## Final try is to dockerize ONOS and Mininet

`No longer valid. A new study can be found here:` [sdn-with-docker](https://github.com/bhuiyan-chafi/sdn-docker)

Let's we just want to emulate the network, we will are not focusing on ONOS app development(which is the main purpose btw!).

Since docker has onos and mininet images, we can create container and connect them thought the same network to see the emulation. But!

![onos-mininet-docker-1](./issues/WhatsApp%20Image%202025-09-07%20at%2011.33.24.jpeg)

![onos-mininet-docker-2](./issues/WhatsApp%20Image%202025-09-07%20at%2011.33.25.jpeg)

The issue is still with your CPU architecture. Mininet requires real UBUNTU kernel to emulate the network(specially OpenVswitch), which is not provided through the container. Will installing an ubuntu container and then installing mininet work? No, also have tried that. In containers a real kernel is never provided.

## Conclusion

So, with macbook air it is not possible to emulate this network lab repository. With macbook pro you can try installing different version of bazel and keep testing if it works with ONOS controller. Because for creating new ONOS app we need `bazel`. Happy testing!
