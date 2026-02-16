# Dockeritzant NGINX

A classe hem utilitzat `docker-compose` per a desplegar 3 aplicacions web diferents: `app1`, `app2` i `app3` en una instancia EC2 d'AWS.

## Configurant de l'entorn multi-aplicació

En primer lloc, hem creat les aplicacions web amb `Flask`. Aquí teniu un exemple del codi per a **app1**:

```python
    ```python
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def home():
        return "Hello from App 1!"

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000)
    ```
```

A continuació, hem creat el fitxer `Dockerfile` per cada aplicació:

```Dockerfile
    FROM python:3.9
    WORKDIR /app
    COPY app.py .
    RUN pip install flask
    CMD ["python", "app.py"]
```

Per app2 i app3, hem fet el mateix, simplement modificant el missatge de retorn. L'estructura de les aplicacions és la següent:

```plaintext
    app1/
    ├── app.py
    └── Dockerfile
    app2/
    ├── app.py
    └── Dockerfile
    app3/
    ├── app.py
    └── Dockerfile
```

Un cop preparades les aplicacions, hem creat un fitxer `docker-compose.yml` per orquestrar els nostres serveis:

```yaml
version: '3.9'

services:
  app1:
    build: ./app1
    container_name: app1
    ports:
      - "5001:5000"
  app2:
    build: ./app2
    container_name: app2
    ports:
      - "5002:5000"
  app3:
    build: ./app3
    container_name: app3
    ports:
      - "5003:5000"
```

Amb aquest fitxer, hem desplegat els serveis mitjançant `docker-compose up -d`. Per accedir a les aplicacions, hem utilitzat la IP pública de la instància EC2 i el port corresponent de cada aplicació.

> **Nota 1**: Recordeu d'obrir els ports corresponents a les aplicacions a la instància EC2 (5001, 5002 i 5003).

---

> **Nota 2**: Recordeu que si feu modificacions als contenidors, heu de fer `docker-compose up --build -d` per aplicar els canvis.

Amb aquesta configuració, hem pogut accedir a les aplicacions a través de `http://ip:5001`, `http://ip:5002` i `http://ip:5003`. Per aconseguir-ho, hem afegit **nginx** com a proxy invers al nostre `docker-compose.yml`:

## Configurant NGINX com a proxy invers

Per evitar accedir a diferents ports per a cada aplicació, l'Alberto ens va suggerir utilitzar un únic punt d'entrada. Així, podem accedir a les aplicacions a través de `http://ip/app1`, `http://ip/app2` i `http://ip/app3`.

- Actualitzeu el vostre `docker-compose.yml` amb el següent contingut:

```yaml
version: '3.9'

services:
  app1:
    build: ./app1
    container_name: app1
    ports:
      - "5001:5000"
  app2:
    build: ./app2
    container_name: app2
    ports:
      - "5002:5000"
  app3:
    build: ./app3
    container_name: app3
    ports:
      - "5003:5000"
  nginx:
    image: nginx:latest
    container_name: nginx
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    ports:
      - "80:80"
```

- Inicialment hem configurat `nginx` de la següent manera:

```nginx
events {}
http {
        server {
            listen 80;
            location / {
                proxy_pass http://127.0.0.1:5001;
            }
            location /app1/ {
                proxy_pass http://127.0.0.1:5001;
            }

            location /app2/ {
                proxy_pass http://127.0.0.1:5002;
            }

            location /app3/{
                proxy_pass http://127.0.0.1:5003;
            }
        }
}
```

No obstant això, després de desplegar-ho, vam observar que les aplicacions no funcionaven i apareixien errors de **connection refused**. Consultant els logs a través de `docker logs nginx`, vam veure que `nginx` no podia connectar-se als contenidors de les aplicacions.

El problema rau en el fet que nginx, al ser un contenidor, no pot utilitzar **127.0.0.1** per connectar-se als altres serveis, ja que aquest **localhost** és específic del contenidor nginx i no de la instància **EC2**. Si el servidor `nginx` fos a la instància EC2, aquesta configuració hauria estat correcta.

Per solucionar-ho, hem actualitzat la configuració de nginx per utilitzar els noms dels serveis definits a docker-compose.yml, que són accessibles dins de la xarxa de contenidors:

```nginx
events {}
http {
        server {

                listen 80;
                location / {
                  proxy_pass http://app1:5000/;
                }
                location /app1/ {
                  proxy_pass http://app1:5000/;
                }

                location /app2/ {
                  proxy_pass http://app2:5000/;
                }

                location /app3/{
                  proxy_pass http://app3:5000/;
                }


        }
}
```

Amb aquesta configuració, nginx utilitza la xarxa interna de Docker per comunicar-se amb els serveis. Un cop implementats els canvis, podem accedir a les aplicacions a través de:

- `http://ip/app1`
- `http://ip/app2`
- `http://ip/app3`

> **Nota**: Ara només cal obrir el port 80 a la instància EC2, ja que nginx redirigeix les peticions al port correcte dins de la xarxa de contenidors. Els ports 5001, 5002 i 5003 ja no són necessaris a AWS.

Amb aquesta configuració, hem aconseguit desplegar 3 aplicacions web diferents amb un únic punt d'entrada, gràcies a **nginx** com a proxy invers.
