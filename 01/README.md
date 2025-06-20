# Домашнее задание к занятию «Организация сети»

## Задание 1.  Yandex Cloud.

```
Что нужно сделать

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
* Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
* Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
* Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
* Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
* Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
* Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.
```
* Создаю VPC, Subnet с названием Public и Private, NAT-инстансе, VM с названием Public c Public IP.

[terraform src](https://github.com/A-Tagir/CloudOrg/tree/main/01/src)

* Проверяю tflint:

![tflint](https://github.com/A-Tagir/CloudOrg/blob/main/01/CloudOrg01_tflint.png)

* Исправляем ошибки и применяем:

![apply_ok](https://github.com/A-Tagir/CloudOrg/blob/main/01/CloudOrg01_apply_ok.png)

* Поключемся к полученному "46.21.246.176" по SSH и проверяем:

![vm_public_ok](https://github.com/A-Tagir/CloudOrg/blob/main/01/CloudOrg01_public_vm_ok.png)

* Видим, что VM в подсети Public и имеет внешний IP и доступ в интернет.

* Теперь добавляем  route table и виртуалку с внутренним IP:

[terraform src](https://github.com/A-Tagir/CloudOrg/tree/main/01/src)

* Применяем:

![private_apply](https://github.com/A-Tagir/CloudOrg/blob/main/01/CloudOrg01_private_apply.png)

* Проверяем:

![private_ok](https://github.com/A-Tagir/CloudOrg/blob/main/01/CloudOrg01_private_ok.png)

* Видим, что к машине private можно подключиться (технология jump host) и она имеет доступ в интернет.
  
