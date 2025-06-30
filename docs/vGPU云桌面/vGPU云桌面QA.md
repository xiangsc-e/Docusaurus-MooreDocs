# vGPU云桌面QA

# 1、驱动加载失败，提示failed to load driver

问题描述：

安装驱动后创建vGPU失败，或者虚拟机开机失败

dmesg | grep "mtgpt"   # 显示disable dma

![image](/img/cloud-desktop/e52cbf25-9b73-4c28-8f05-5932067f5d96.png)

原因分析： 服务器IOMMU没有Enable

解决办法：BIOS开启服务器的IOMMU，具体请参考各家服务器BIOS配置手册，在调整完服务器BIOS配置之后，需要在操作系统层面做如下配置。

```shell
1、更新操作系统grub文件，开启IOMMU, 在/etc/default/grub中添加intel_iommu=on
GRUB_CMDLINE_LINUX="....intel_iommu=on"
2、更新grub，方法根据当前操作系统手动更新，更新后reboot服务器
grub2-mkconfig -o /boot/grub2/grub.cfg
备注： -o目录需要根骨当前系统版本启动方式来确定文件位置，如uefi/legecy修改
```

# 2、无法使用GPU加速

问题描述：

无法使用GPU加速，任务管理器中不能看到GPU设备，打开设备管理器->显示适配器，可以看到Moore Threads S3000 MT vGPU-110X，但是带有黄色感叹号

任务管理器：

![image](/img/cloud-desktop/9d0ba767-81ad-42c8-906a-84554379c598.png)

设备管理器：

![image](/img/cloud-desktop/c12a59cf-6fb0-456f-a0d0-3a721d79cbf2.png)

原因分析：

1、驱动版本查看 

服务器： rpm -qi mtvgpu 

云主机：任务管理器查看GPU驱动时间

2、驱动版本不匹配时

dmesg | grep "Version mismatch" 可以看到类似信息

![image](/img/cloud-desktop/d7b6b1b9-8acf-46c3-8843-13320b4d82b8.png)

解决办法：

1、重启虚拟机能否解决

2、重启虚拟机，检查虚拟机有无GPU升级提醒，如有升级提醒升级到最新版本驱动解决

3、如果重启不能解决请收集日志报告问题

# 3、虚拟机驱动升级失败

问题描述：

虚拟机驱动升级后，虚拟机收到驱动升级提醒，根据升级提醒升级，最后提示升级失败，或者审计过程中虚拟机出现蓝屏，重启等意外事故中断升级

解决方法：

1、重启虚拟机，如果能收到升级提醒，继续升级流程

2、重启虚拟机，不能收到升级提醒，需要手动安装对应版本的PES驱动程序

# 4、网页、客户端视频播放黑屏

问题描述：

爱奇艺、优酷客户端或者网页上部分视频播放黑屏，部分视频正常播放，正常播放的视频始终可以正常播放，黑屏视频始终黑屏，但是广告部分可以正常播放

解决方法：

1、加密视频，应用禁止抓屏，客户端暂无法解决

2、chrome浏览器，设置>更多权限>受保护的内容ID，设置不允许网站使用标识符播放受保护的内容

![image](/img/cloud-desktop/20f97420-1ee0-4c99-8d9a-be542c616951.png)

３、edge浏览器，设置＞Coookie和网站权限>所有权限>受保护内容ID>关闭允许受保护内容的标识符

![image](/img/cloud-desktop/4949f8be-84fb-4b75-9135-2d38875b089f.png)

# 5、虚拟机蓝屏

问题描述：

出现蓝屏，失败的操作：mtkmd64.sys或者mtxxx

![image](/img/cloud-desktop/1cd001a4-e34d-4e27-8005-598bf9dbd87e.png)

解决办法

1、收集日志上报问题

虚拟机内收集

C:\Windows\MEMORY.DMP

2、服务器收集

/var/log/memsage

/var/log/hwr\_coremem\_gpuxx\_xx

/var/log/hwr\_trace\_gpuxx\_xx

# 6、PotPlayer播放视频卡顿

问题描述：

使用Potplayer播放视频时CPU占用率高，打开任务管理器，CPU利用率较高，GPU中Video Decode没有利用率波动，播放视频卡顿

![image](/img/cloud-desktop/2cc0bf48-0e41-42ec-b580-20e0ffbef154.png)

解决办法：

在Potplayer中打开硬件解码，点击右下角S/W，点击后图标变成黄色HW，任务管理器中可以看到Video Decode有利用率波动

![image](/img/cloud-desktop/37156e4c-8029-4ae4-b718-1f258b5d34d5.png)

# 7、CPU利用率低，GPU利用率高，桌面卡顿

问题描述：

打开任务管理器，查看CPU利用率不高，GPU利用率超过80%，共享GPU内存使用较多，桌面操作卡顿，或者使用应用卡顿

![image](/img/cloud-desktop/94f45d26-af21-49ea-9225-01e35b9a44f7.png)

查看应用占用显存情况，点击详细信息，右键选择列

![image](/img/cloud-desktop/a8a3a564-51c7-45ed-8033-a09a5d197ec5.png)

添加”专用GPU内存“，”共享GPU内存“

![image](/img/cloud-desktop/6a83567b-528e-4266-a29f-ce13e59933bf.png)

![image](/img/cloud-desktop/a9f3e5c6-50bd-44a8-b49c-3858201ed456.png)

解决方法：

1、关闭当前没有使用的应用，释放显存

2、升级vGPU规格，使用更大显存的vGPU

# 8、虚拟机4K桌面模糊，图像发生畸变

问题描述：

客户反馈虚拟机内画面不清晰，4K桌面在4096x2160分辨率下会出现此问题

解决方法：

1、已知问题，需要使用3840\*2160分辨率的显示器，或者设置当前显示器分辨率为3840\*2160

# 9、生成大量垃圾文件，占满guset磁盘

日期：2025/06/05

客户：杭研

驱动版本： 2.5.6

问题描述：客户发现vGPU驱动程序一直在往C:\windows\Temp\目录下写文件，已经占满了客户磁盘空间

如下是通过资源管理器>性能>左下角"打开资源监视器">关联句柄处通过输入文件即可查看关联的程序

![10d3922e01dd2d555db9053c37c9dfcb.jpeg](/img/cloud-desktop/cb11855b-fc98-404d-84e5-4c03bbf237df.jpeg)

问题分析： 

杭研云平台在本来是使用CPU云桌面的客户使用了GPU云桌面虚拟机模板，GPU虚拟机模板安装了vGPU的驱动，但是虚拟机并没有实际绑定vGPU，而在2.5.6的版本中驱动程序会一直处于保活状态，会反复的重启，每次重启会在C: \Windows\Temp\\_MEI\*\\*目录下生成临时文件。

备注： 在2.7.5及后续版本这个问题做了优化，在没有绑定vGPU的情况下，进程也不会反复启停，同时就算进程退出，也不会残留文件。

解决办法：

通过如下脚本方式清楚，因为数量较多，同时因平台限制，通过中兴云平台推送脚本到虚拟机执行

[请至钉钉文档查看附件《clean\_mei-0605-1816.bat》](https://alidocs.dingtalk.com/i/nodes/X6GRezwJlYDPDljAtnaDb0wp8dqbropQ?doc_type=wiki_doc&iframeQuery=anchorId%3DX02mbovbhtqwzn7d7xhby)
