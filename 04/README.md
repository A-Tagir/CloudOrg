# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

## Задание 1.  Yandex Cloud.

```
1. Настроить с помощью Terraform кластер баз данных MySQL.
 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость.
 - Разместить ноды кластера MySQL в разных подсетях.
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.
 - Задать время начала резервного копирования — 23:59.
 - Включить защиту кластера от непреднамеренного удаления.
 - Создать БД с именем netology_db, логином и паролем.
2. Настроить с помощью Terraform кластер Kubernetes.
 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами.
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
 - Подключиться к кластеру с помощью kubectl.
 - Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.
```

* Создаем необходимые сети private1-private3 для кластера MySQL и public1-public3 для кластера Kubernetes:

[network.tf](https://github.com/A-Tagir/CloudOrg/blob/main/04/src/network.tf)

* Создаем кластер MySQL согласно заданию в зонах a, b и d:

[mysql.tf](https://github.com/A-Tagir/CloudOrg/blob/main/04/src/mysql.tf) 

* Здесь важно отметить, что версию провайдера лучше использовать последнюю 0.145 и выше.
  Версия 0.135 завершалась с ошибкой и не могла довести создание кластера до конца.
* Также нужно отметить, что в зоне d недоступна конфигурация с Intel Broadwell, а зона c недоступна совсем.
  Поэтому, было принято решение использовать Intel Cascade Lake которая доступна во всех зонах и доступа в 
  варианте Burstable.

* Применяем:

![ClusterCreated](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_ClusterCreated.png)

* После некоторых мучений, все успешно, также смотрим в консоли ycloud:

![ClusterCreatedConsole](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_ClusterCreatedConsole.png)

* Видим, что топология соответствует заданию:

![ClusterCreatedHosts](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_ClusterCreatedHosts.png)
![ClusterCreatedTopology](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_ClusterCreatedTopology.png)

* Теперь создаем распределенный кластер кубернетес:

[k8s.tf](https://github.com/A-Tagir/CloudOrg/blob/main/04/src/k8s.tf)

* Здесь нужно отметить, что для простоты, правила сети "разрешено все". Кроме того, вокер-ноды могут масштабироваться
  только в пределах одной зоны. Поэтому, для простоты делаем одну node_group в зоне а.
* Также задаем размер hdd 64 и RAM 4. С hdd 20 и RAM 2 группа зависала в "created".
* KMS используем из предыдущих заданий. Весь проект здесь:

[src](https://github.com/A-Tagir/CloudOrg/tree/main/04/src)

* Применяем(Ранее созданный MySQL удалил, поэтому запускаю весь проект):

![KubeAndMySQLCreated](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_KubeAndMySQLCreated.png)

* Видим, что через некоторое время кастеры создались. Подключаем kubectl:
```
 yc managed-kubernetes cluster    get-credentials cativ0rfjbun9md852cv --external

Context 'yc-netology-cluster' was added as default to kubeconfig '/home/tiger/.kube/config'.
Check connection to cluster using 'kubectl cluster-info --kubeconfig /home/tiger/.kube/config'.

Note, that authentication depends on 'yc' and its config profile 'netology-homework'.
To access clusters using the Kubernetes API, please use Kubernetes Service Account.
tiger@VM1:~/CloudOrg/04/src$ kubectl get nodes
NAME                        STATUS   ROLES    AGE     VERSION
cl1ho4pg4tvddndbv9md-ahof   Ready    <none>   4m30s   v1.29.1
cl1ho4pg4tvddndbv9md-ajul   Ready    <none>   4m7s    v1.29.1
cl1ho4pg4tvddndbv9md-amyq   Ready    <none>   3m52s   v1.29.1
```
* Видим, что ноды живые. Теперь создаем phpmyadmin:

[myadmin.yaml](https://github.com/A-Tagir/CloudOrg/blob/main/04/src/yaml/myadmin.yaml)

* Применяем:
```
tiger@VM1:~/CloudOrg/04/src$ kubectl apply -f ./yaml/myadmin.yaml
deployment.apps/phpmyadmin created
service/phpmyadmin-service unchanged
tiger@VM1:~/CloudOrg/04/src$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
phpmyadmin-85dfc9d979-2dk8q   1/1     Running   0          12s
phpmyadmin-85dfc9d979-mflh9   1/1     Running   0          12s
tiger@VM1:~/CloudOrg/04/src$ kubectl get svc
NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
kubernetes           ClusterIP      10.96.128.1    <none>         443/TCP        44m
phpmyadmin-service   LoadBalancer   10.96.174.31   51.250.42.28   80:31703/TCP   2m18s

```
* Заходим на балансер:
![PhpMyAdmin](https://github.com/A-Tagir/CloudOrg/blob/main/04/CloudOrg04_PhpMyAdmin.png)

* Видим что база данных доступна.
* Удаляем конструкцию.
