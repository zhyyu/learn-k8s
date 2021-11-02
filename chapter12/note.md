# ServiceAccount
- sa 是和namespace 关联
- kubectl get sa
  - 获取sa
- pod yaml 指定serviceAccount， 如果不指定，使用命名空间中默认sa
- 创建serviceAccount
  - kubectl create serviceaccount foo
    ```
    yuzhongyu@yuzhongyudeMacBook-Air chapter12 % kubectl describe sa foo 
    Name:                foo
    Namespace:           default
    Labels:              <none>
    Annotations:         <none>
    Image pull secrets:  <none>
    Mountable secrets:   foo-token-q2z8w
    Tokens:              foo-token-q2z8w
    Events:              <none>


    yuzhongyu@yuzhongyudeMacBook-Air chapter12 % kubectl get secrets 
    NAME                  TYPE                                  DATA   AGE
    default-token-b9nlz   kubernetes.io/service-account-token   3      37d
    foo-token-q2z8w       kubernetes.io/service-account-token   3      2m46s
    ```

- 将 ServiceAccount 分配给 pod
  - pod 创建时设置， 后续不能被修改

---
# 通过基于角色的权限控制加强集群安全
pending
