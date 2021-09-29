# 向容器传递命令行参数
- kubectl create -f fortune-pod-args.yaml

# 为容器设置环境变量
- kubectl create -f fortune-pod-env.yaml

# ConfigMap
- 创建cm
  - kubectl create -f fortune-config.yaml
  - 根据文件/文件夹创建cm
    - kubectl create configmap fortune-config-files --from-file configmap-files
- 查看cm
  - kubectl get cm
  - kubectl describe cm fortune-config

# 使用ConfigMap 卷将configmap 记录暴露为文件
- 创建configmap
  - kubectl create configmap fortune-config-files --from-file configmap-files
    - 登陆nginx /etc/nginx/conf.d  目录， 发现两 my-nginx-config.conf  sleep-interval 文件
