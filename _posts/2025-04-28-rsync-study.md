---
layout: post
title: "Rsync Usage Summary"
date: 2025-04-18
categories: Rsync Study

---



## Introduction

`rsync`，全称是 `remote sync`，字面意思是做**远程同步**的，但是 `rsync` 能做的不只是远程同步，还能做：

* 文件拷贝；
* 系统备份；
* 远程文件传输；

等。`rsync` 完全能够替代常见的 `cp` / `mv`/ `scp` (secure copy) 等文件拷贝、移动和远程传输等命令。

**`rsync` 最大的的用途是可以做增量备份，即 `rsync` 在第一次执行备份时，是全量备份（将所有的文件都备份），后面再重新备份时，只会备份哪些修改过的文件。**

`rsync` 命令支持的参数非常多，下面就每一种参数的具体使用情景，做详细的说明。

### Installation

如果本机或者远程计算机没有安装 rsync，可以用下面的命令安装。

> ```bash
>
> # Debian
> $ sudo apt-get install rsync
>
> # Red Hat
> $ sudo yum install rsync
>
> # Arch Linux
> $ sudo pacman -S rsync
> ```

注意，传输的双方都必须安装 rsync。

### Usage

```
rsync [options] [source] [target]
```

其中：

* options 表示各种可选参数，是下面要详细介绍的；
* source 表示原文件或者原目录，可以是本地的，也可以是远程的；
* target 表示目标目录，可以是本地的，也可以是远程的。

下面介绍各参数的使用方法:

#### `-r` 参数

Linux 中的 `-r` 参数基本都是 `recursively` 的意思，也就是 **递归** ， **一般是面向目录** ，例如 `cp` 命令中的 `-r` 参数，`rm` 命令中的 `-r` 参数。

**注意**，`-r` 参数虽然能够递归的对一个目录进行拷贝，或者传输，**但是，其只传递文件内容，不传输文件的一些属性信息，如修改时间，文件所有者，文件权限等。**比方说，当你使用 `rsync` 传递文件从一个地方到另一个地方之后，文件的所有者不再是原来的所有者，而变成了你。（即文件所有者信息不回被传递）

解释了这么多，来看几个使用 `rsync` 复制文件、传输文件的例子。

1. 拷贝文件到一个本地目标目录

```
rsync source.txt ~/target/
```

需要强调的是， **如果目标目录不存在，`rsync` 会自动创建该目录** 。

2. 拷贝目录到一个本地目标目录

假设 `test4` 目录下面有两个文件 `test.text`和 `t.sh`，现在想将 `test4` 目录拷贝到 `test2` 目录下，形成 `test2/test4` 这种结构，可以这么做：

```
rsync -r test4 test2/
```

拷贝完，我们看看 `test4` 的内容：

```
❯ ls test4
test.text  t.sh
❯ rsync -r test4 test2/
❯ ls test2
test4  test.text  t.sh
❯ ls test2/test4
test.text  t.sh
```

但是，如果我们在 `test4` 后面加上 `/`，结果就不一样了：

```
rsync -r test4/ test2/
```

结果：

```
❯ ls test2
❯ rsync -r test4/ test2/
❯ ls test2
test.text  t.sh
❯ ls test4
test.text  t.sh
```

也就是说：

* **源目录带有 `/`，将拷贝其子文件和子目录，该目录本身不会出现在目标目录；**
* **源目录不带 `/`，将拷贝源目录本身。**
* **目标目录带 `/` 或者不带 `/` ，均不影响** 。

#### `-a` 参数

前面说了，`-r` 参数不会将 `modified time` ，`owner`，`permition` 等属性拷贝到目标文件，那如果想要保持这些信息呢？那就用 `-a` 参数！

 **实际上，用 `rsync` 做文件备份，基本只会用 `-a` 参数，而不会使用 `-r` 参数** 。

`-a` 参数可以在拷贝单个文件时用，也可以在拷贝目录时用。拷贝目录时，使用 `-a` 就不需要再用 `-r` 了。

1. 拷贝单个文件

```
rsync -a source.txt ~/target/
```

2. 拷贝一个目录

```
rsync -a test4 test2/
```

上面的拷贝会形成 `test2/test4` 的目录结构。如果不想拷贝该目录本身，可以在 `test4` 后面加上 `/` :

```
rsync -a test4/ test2/
```

#### `-v` 参数

在 Linux 中，`-v` 在很多情况下，表示 `verbose`，也就是 **在命令执行过程中会输出很多信息** 。在 `rsync` 命令中，`-v` 会将拷贝的整个过程打印在屏幕上。

```
❯ rsync -av test4/ test2/
sending incremental file list
./
t.sh
test.text

sent 777 bytes  received 57 bytes  1,668.00 bytes/sec
total size is 588  speedup is 0.71
```

#### `-z` 参数

在 Linux 中，`-z` 参数一般表示压缩的意思（想想 `tar` 命令中的 `z` 参数表示用 `gzip` 压缩和解压缩）。

使用这个参数，`rsync` 会首先将需要拷贝或传输的数据压缩，到了 destination，进行解压缩，整个过程中用户不需要手动做压缩和解压，`rsync` 全帮用户做好了，这样就能减少需要传输的文件大小。

```
span
```

使用这个参数，可以将文件拷贝或者传输的过程给显示出来，看下面例子的执行结果就知道了：

```
span
```

#### `-e` 参数

`-e` 参数后面接 `ssh` 表示我现在想要在本地和远程服务器之间，通过 ssh 协议来相互传输文件。

1. 将本地文件传递到远程

rsync -a -e ssh source.txt `<username>`@`<hostname>`

2. 将本地目录传递到远程

rsync -a **-e ssh** test1/ `<username>`@`<hostname>`

同样的，将远程文件或者目录拉取到本地，只需要将 `[source]` 和 `[target]` 参数调换一下位置即可。

有时候 ssh 为了安全起见，不是使用默认的 22 端口，改成了， 例如 1213 端口（为了安全起见防止攻击），这时候还想使用 `rsync` 在本地和远程之间传输文件，也不难。

* 将本地文件传输到服务器

rsync -a **-e 'ssh -p 1213'** source.txt `<username>`@`<hostname>`

* 将服务器目录拉取到本地

rsync -a **-e 'ssh -p 1213'** test2 . # 将 test2 目录拉取到当前目录，形成 ./test2/ 的目录结构

#### 其它

`rsync` 其实还有很多其他的参数：

* `--include` : 包含指定文件；
* `--exclude`：不包含指定类型文件或目录；
* `--dry-run`：模拟 `rsync` 的执行，看看执行后会发生什么，但实际上 `rsync` 并没有执行；
* **`--delete`** ：在做备份时使用。如果我们的目标目录只想做源目录的一个 **镜像** ，即目标目录中**不包含**源目录中没有的文件，这时候，在使用 `rsync` 时带上 `--delete` 参数，就可以将目标目录中，那些不在源目录中的文件删除掉。

More使用细节:  [rsync examples](https://rsync.samba.org/examples.html)

### 增量备份

`rsync` 最强大的功能就是做增量备份了，即第一次执行备份时，是做全量备份，后面再执行 `rsync` 做备份时，就是做增量备份了。

我们可以使用 `crontab` 来帮助我们做定时备份。

首先 `crontab -e` 来新建一个例行性工作：

会自动调用 vim 编辑器打开 `crontab` 文件，接着在里面按照 `crontab` 的时间格式，写入一行，例如下面的：

00 00 * * * rsync -avz /home/kyle/Documents /media/kyle/usb-disk/backups/

上面的命令，就会每天在 `00:00` 时刻，将我的 Documents 文件夹备份到外接的硬盘 `usb-disk` 的 `backups` 文件夹中。


### References

`rsync` 的具体使用细节，可以参考前三篇文章；`rsync` 用来备份系统，可以参考阮一峰文章中的增量备份一节，和引用列表最后那一篇文章。

* [【阮一峰】rsync 用法教程](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
* [Rsync (Remote Sync): 10 Practical Examples of Rsync Command in Linux](https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)
* [How to Sync Files/Directories Using Rsync with Non-standard SSH Port](https://www.tecmint.com/sync-files-using-rsync-with-non-standard-ssh-port/)
* [How to Back Up Your Linux System](https://www.howtogeek.com/427480/how-to-back-up-your-linux-system/)
* [rsync examples](https://rsync.samba.org/examples.html)
* [How Rsync Works A Practical Overview](https://rsync.samba.org/how-rsync-works.html)
* [rsync.1#opt--inc-recursive](https://download.samba.org/pub/rsync/rsync.1#opt--inc-recursive)
