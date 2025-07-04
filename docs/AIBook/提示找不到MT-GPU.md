# 提示找不到MT GPU

1、故障现象

![image.png](/img/aibook/e3155977-4016-4ffb-b3a2-4bb36c836e9a.png)

2、原因

系统版本： Linux ab-AIBOOK-ABA14001 6.6.10

系统内核导致，因内部对驱动内核结构进行了调整，在2025年5月9号前的镜像内核中移除了该驱动，该驱动在5月10号重新合入了镜像，所以在2025年05月9日之前一段时间的镜像回存在无法执行pes的情况

3、解决办法

1）临时解决，手动加载如下内核模块

[请至钉钉文档查看附件《ac\_ioctl\_m.ko》](https://alidocs.dingtalk.com/i/nodes/7dx2rn0Jba9n9vGYT5wybR9PVMGjLRb3?doc_type=wiki_doc&iframeQuery=anchorId%3DX02mcaf7wb68uo0n5j19z8)

```shell
# insmod常用于临时加载模块，重启后失效
sudo insmod ac_ioctl_m.ko
# 或者，modprobe会动在家依赖的模块，较常用
sudo modporbe ac_ioctl_m
# 检查是否加载成功
lsmod | grep ac_ioctl_m
```

2）长期生效

```shell
# 将上述的ko文件上传至系统, 并拷贝到如下目录
sudo mkdir -p /lib/modules/6.6.10/kernel/drivers/firmware/m1000/
sudo cp ac_ioctl_m.ko /lib/modules/6.6.10/kernel/drivers/firmware/m1000/
sudo depmod -a    #表示更新所有模块的依赖关系
```
