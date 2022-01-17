### API

Добавить IP-адрес к подсчету статистики

`curl -XPOST http://localhost:3000/api/v1/ip_availability/127.0.0.1/add`

Удалить IP-адрес из подсчета статистики

`curl -XDELETE http://localhost:3000/api/v1/ip_availability/127.0.0.1/remove`

Сообщить статистику доступности IP-адреса по ICMP

`curl -XGET http://localhost:3000/api/v1/ip_availability/127.0.0.1/stats/1642431600-1642442400`
