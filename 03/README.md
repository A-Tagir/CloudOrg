# Домашнее задание к занятию «Безопасность в облачных провайдерах»

## Задание 1.  Yandex Cloud.

```
Что нужно сделать
1. СС помощью ключа в KMS необходимо зашифровать содержимое бакета:
 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:
 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).
```
* Создаю необходимые сети:

[networks.tf](https://github.com/A-Tagir/CloudOrg/blob/main/03/src/network.tf)

* создаю бакет и помещаю картинку:

[bucket.tf](https://github.com/A-Tagir/CloudOrg/blob/main/03/src/bucket.tf)

* Создаю ключ kms symmetric key для шифрования бакета, создаю роль для шифрования бакета. Зашифрованный бакет не может быть
  публичным, поэтому делаем его private и после создания получаем ссылку (срок действия 30 дней) через консоль.
  (Это можно было бы сделать также через terraform + aws cli). Эту ссылку помещаем в шаблон инстанса.

![access_link](https://github.com/A-Tagir/CloudOrg/blob/main/03/CloudOrg03_access_link.png)

[key.tf](https://github.com/A-Tagir/CloudOrg/blob/main/03/src/key.tf)

* Весь проект:

[src](https://github.com/A-Tagir/CloudOrg/tree/main/03/src)

* Применяем:
```
yc iam create-token
terraform apply -var "token="

```

![encrypted_bucket](https://github.com/A-Tagir/CloudOrg/blob/main/03/CloudOrg03_Encrypted_bucket.png)

* Видим, что создался ключ
  
![key_id](https://github.com/A-Tagir/CloudOrg/blob/main/03/CloudOrg03_key_id.png)

* Пробуем получить доступ к изображению и видим, что оно недоступно:

![no_access](https://github.com/A-Tagir/CloudOrg/blob/main/03/CloudOrg03_no_access.png)

* Но если зайти в приложение через адрес балансировщика, то изображение есть, потом-то там созданная ссылка на зашифрованный объект:

![access_ok](https://github.com/A-Tagir/CloudOrg/blob/main/03/CloudOrg03_access_ok.png)
