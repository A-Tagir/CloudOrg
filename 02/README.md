# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»

## Задание 1.  Yandex Cloud.

```
Что нужно сделать

1. Создать бакет Object Storage и разместить в нём файл с картинкой:
  * Создать бакет в Object Storage с произвольным именем (например, имя_студента_дата).
  * Положить в бакет файл с картинкой.
  * Сделать файл доступным из интернета.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на   картинку из бакета:
  * Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать image_id = fd827b91d99psvq5fjit.
  * Для создания стартовой веб-страницы рекомендуется использовать раздел user_data в meta_data.
  * Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
  * Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
  * Создать сетевой балансировщик.
  * Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

```
* Создаю необходимые сети:

[networks.tf](https://github.com/A-Tagir/CloudOrg/blob/main/02/src/network.tf)

* создаю бакет и помещаю картинку:

[bucket.tf](https://github.com/A-Tagir/CloudOrg/blob/main/02/src/bucket.tf)

* Создаю сервисный аккаунт, инстанс группу согласно заданию и сетевой балансировщик. 
  В процессе работы выяснилось, что удаление инстанс группы не происходит и 
  пришлось добавить в зависимости сервисный аккаунт. После этого все четко.
  В инстансах внешнего IP не предусмотрел. Включил для отладки, но потом удалил:

[main.tf](https://github.com/A-Tagir/CloudOrg/blob/main/02/src/main.tf)

* Весь код здесь:

[src](https://github.com/A-Tagir/CloudOrg/tree/main/02/src)

* Применяем:
```
yc iam create-token
terraform apply -var "token="

```
![apply_ok](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_apply_ok.png)

* Видим что созданы 3 VM:

![VMs_OK](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_vms_ok.png)

* Видим что создан сетевой балансировщик, IP адрес его, также есть в output:

![NetworkBalancer](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_nbalancer_ok.png)

* Заходим на http://http://51.250.32.197/ и видим по ID, что запрос направлен на VM3 из группы:

![VM3_response](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_vm3_response.png)

* Обновляем и видим, что теперь запрос направлен на VM1 из группы:

![VM1_response](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_vm1_response.png)

* Останавливаем VM1 и VM3:

![vms_stopped](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_vms_stopped.png)

* обновляем и видим, что сервер отдает картинку с VM2:

![VM2_response](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_vm2_response.png)

* Также я замечаю, что остановленные машины запустились сами через некоторое время.

* Удаляю ресурсы:

![destroy_ok](https://github.com/A-Tagir/CloudOrg/blob/main/02/CloudOrg02_tf_destroy_ok.png)

* Успешно удалились.
  
  


