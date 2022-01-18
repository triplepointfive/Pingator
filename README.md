## Приложение Пингатор

Умеет получать IP-адрес который нужно пинговать, останавливать пинг для этого адреса и отдавать статистику доступности за выбранный период

Для проверки доступности должна быть активна rake задача `rake pinger`

### API

#### Добавить IP-адрес к подсчету статистики

`curl -XPOST http://localhost:3000/api/v1/ip_availability/127.0.0.1/add`

Успех: `{"status":"ok"}`

#### Удалить IP-адрес из подсчета статистики

`curl -XDELETE http://localhost:3000/api/v1/ip_availability/127.0.0.1/remove`

Успех: `{"status":"ok"}`

#### Сообщить статистику доступности IP-адреса по ICMP

`curl -XGET http://localhost:3000/api/v1/ip_availability/127.0.0.1/stats/1642431600-1642442400`

Успех: `{"status":"ok","result":{"average":0.024,"minimum":0.02,"maximum":0.03,"median":0.023,"standard_deviation":0.003,"lost":0.0}}`
