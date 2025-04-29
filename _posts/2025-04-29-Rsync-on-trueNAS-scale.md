---
layout: post
title: "Rsync on TrueNAS Scale Usage"
date: 2025-04-18
categories: Rsync provides fast incremental data transfer to synchronize files between a TrueNAS host and a remote system
---
## Introduction

[Rsync](https://rsync.samba.org/) provides fast incremental data transfer to synchronize files between a TrueNAS host and a remote system.

The **Push** function copies data from TrueNAS to a remote system.

The **Pull** function copies data from a remote system to the TrueNAS local host system, and stores it in the dataset defined in the **Path** field.

There are two ways to connect to a remote system and run an rsync task:

* Set up an **SSH connection** to the remote server.
* Set up an **rsync module** for the remote server.

Are there any practical benefits in using `rsyncd` compared to rsync over ssh? Does it *really* increase speed, stability, anything?

I think the big difference is that if you're using `rsyncd` on the server end, instead of `rsync` over `ssh`, the server already knows what it has, so building the file lists to determine what needs to be transferred is much simpler. It won't make a difference if you're just pushing around a few files.

This is an old question, but there is another very valid reason for using `rsync` in daemon mode versus over ssh:

* Lower CPU overhead.

Now I need move 16TB data( one day ) from NAS1 to NAS2 with compression level ZSTD. The encryption overhead still results in at best 2.71- 4.14 Gbps, on 10 gigabit ethernet network.
![2025-04-29_10-19.png](/assets/img/2025-04-29_10-19.png)

Using a rsync daemon on one end removes the crypto overhead, and achieves 3.7 - 5.0Gbps transfers for large, contiguous files.
![2025-04-29_14-41.png](/assets/img/2025-04-29_14-41.png)

## Installing the Rsync Daemon Application

1. To install this application, go to  **Apps** , click on  **Discover Apps** , then either begin typing rsync into the search field or scroll down to locate the **Rsync Daemon** application widget.
2. Click on the widget to open the application **Rsync Daemon** information screen.
3. Click **Install** to open the **Install Rsync Daemon** configuration screen.
4. Accept the default value or enter a name in  **Application Name**.
5. Accept the **Network Configuration** default port number (30026) the Rsync app listens on.
6. Add and configure at least one module. A module creates an alias for a connection (path) to use rsync with. Click **Add** to display the **Module Configuration** fields. Enter a name and specify the path to the dataset this module uses for the rsync server storage. Leave **Enable Module** selected. Select the type of access from the **Access Mode** dropdown list. Accept the rest of the module setting defaults. To limit clients that connect, enter IP addresses in **Hosts Allow** and  **Hosts Deny** .
7. Accept the default for the rest of the settings.
8. Accept the default values in **Resources Configuration** or enter the CPU and memory values for the destination system.
9. Click  **Save** . ![RsyncDAppInstalled.png](/assets/img/RsyncDAppInstalled.png)

## Testing the Rysnc Directories

To test your connection to the rsync daemon and find which paths are available to you, simply connect from your client to the rsync host using the following method. This method runs only part of a pull command but will reveal paths for you.

```
rsync -rdt rsync://IPADDR:RsyncPort/

$ rsync -rdt rsync://10.1.1.130:30026   
logs     
```

And once you find the file, you can complete the command and pull it in.

```
rsync -rdt rsync://IPADDR:RsyncPort/DirectoryName/File /DestinationDirectory/
```


## References

* [How to Set Up an Rsync Daemon on Your Linux Server](https://www.atlantic.net/vps-hosting/how-to-setup-rsync-daemon-linux-server/)
* [24.10 (Electric Eel)/SCALE Tutorials/Data Protection/Configuring Rsync Tasks](https://www.truenas.com/docs/scale/24.10/scaletutorials/dataprotection/rsynctasksscale/)
* [Documentation Hub/TrueNAS Apps/Community Apps/Rsync Daemon](https://www.truenas.com/docs/truenasapps/communityapps/rsyncd/)
