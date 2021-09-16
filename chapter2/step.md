# 创建应用
- app.js

# 编写 dockerfile
- Dockerfile

# 构建镜像
- docker build -t my-first-image

# 运行镜像
- docker run -p 8099:8088 -d my-first-image:latest
- -p 宿主机port: 应用port
- curl localhost:8099 测试容器启动

# push image
- docker tag my-first-image zhyyu2016/my-first-image
    - zhyyu2016 为docker hub id
- docker login
- docker push zhyyu2016/my-first-image
