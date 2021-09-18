# docker operate
- 创建应用
  - app.js
- 编写 dockerfile
  - Dockerfile
- 构建镜像
  - docker build -t my-first-image
- 运行镜像
  - docker run -p 8099:8088 -d my-first-image:latest
  - -p 宿主机port: 应用port
  - curl localhost:8099 测试容器启动
- push image
  - docker tag my-first-image zhyyu2016/my-first-image
      - zhyyu2016 为docker hub id
  - docker login
  - docker push zhyyu2016/my-first-image


-----
# k8s operate
- 部署node.js 应用
  - kubectl run my-first-image --image=zhyyu2016/my-first-image --port=8088
- 列出 pod
  - kubectl get pods
  - kubectl get pods -A (包含其他namespace pod)
- 创建一个服务对象
  - kubectl expose pod my-first-image --type=LoadBalancer --name my-first-image-http
  - minikube: minikube service my-first-image-http 获取可以访问服务的 IP 和端口
- 列出服务
  - kubectl get services
- 列出 pod 时显示 pod IP 和 pod 的节点
  - kubec七1 ge七pods -o wide
- 使用kubectl describe 查看 pod 的其他细节
  - kubectl describe pod kubia-hczji
