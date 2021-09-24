# ReplicationController
- 创建rc
  - kubectl create -f my-first-rc.yaml

- 获取rc
  - kubectl get rc
  - kubectl describe rc my-first-rc01

- 修改rc
  - kubectl edit rc my-first-rc01

- 扩缩容
  - kubectl scale rc my-first-rc01 --replicas 6
  - kubectl edit rc my-first-rc01 (spec.replicas 字段)

- 删除rc
  - kubectl delete rc my-first-rc01 (删除rc 下所有pod)
  - delete rc my-first-rc01 --cascade=orphan (保留pod)

# ReplicaSet
- create rs
  - kubectl create -f my-first-rs.yaml 

- rc 复杂selector

```yaml
selector:
  matchExpressions:
    - key: app
      operator: In
      values:
        - my-first-app01
```

# DaemonSet
- 每个select node 运行一个pod

# Job
- 创建job
  - kubectl create -f my-first-job.yaml
- 查看job
  - kubectl get jobs

# CronJob

