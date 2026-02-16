# Exercisis amb Docker i Docker Compose

1. Donada la següent aplicació en Python:

    ```python
    import falcon

    class Item:
        def __init__(self, id, name):
            self.id = id
            self.name = name

    items = [
        Item(1, "Item 1"),
        Item(2, "Item 2"),
        Item(3, "Item 3"),
    ]

    class ItemListResource:
        def on_get(self, req, resp):
            resp.media = [{"id": item.id, "name": item.name} for item in items]

    class ItemResource:
        def on_get(self, req, resp, item_id):
            item = next((i for i in items if i.id == int(item_id)), None)
            if item:
                resp.media = {"id": item.id, "name": item.name}
            else:
                resp.status = falcon.HTTP_404
                resp.media = {"error": "Item not found"}


    app = falcon.App()

    app.add_route('/items', ItemListResource())
    app.add_route('/items/{item_id}', ItemResource())
    ```

    Per executar l'aplicació, es pot fer servir el següent script:

    ```bash
    gunicorn -b 0.0.0.0:8000 app:app
    ```

    On `app` és el nom del fitxer on es troba l'aplicació.

    A més, sabem que l'aplicació necessita les següents llibreries: `falcon` i `gunicorn` en les versions 3.0.0 i 20.1.0 respectivament.

    La teva tasca és crear un Dockerfile per a aquesta aplicació i un fitxer Makefile que permeti construir la imatge i executar-la.

2. Analitza el següent projecte Dockeritzat [Laboratoris](https://github.com/AMSA-2425-GEI-UDL) i desplega'l en el teu entorn de desenvolupament.

3. Crea un fitxer `docker-compose.yml` que permeti desplegar 3 aplicacions web diferents, i un servidor nginx que faci de balancejador de càrrega entre elles. Per fer-ho, farem servir aplicacions web molt senzilles en Python amb Flask. A continuació, es mostren els fitxers de les aplicacions:

    ```python
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def home():
        return "Hello from App 1!"

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000)
    ```

    > Nota: Per instal·lar docker-compose a Amazon linux 2023, es pot fer servir el següent script:
    >
    > ```bash
    > sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    > sudo chmod +x /usr/local/bin/docker-compose
    > ```

4. A la feina us han demanat una arquitectura de desplegament escalable i portable per desenvolupar una app web que fa consultes a una base de dades. La estructura del projecte és la següent:

    ```plaintext
    web-app/
    ├── app/
    │   ├── main.py
    │   ├── models.py
    │   ├── database.py
    │   ├── schemas.py
    │   ├── requirements.txt
    ├── db/
    │   ├── init.sql
    ```

    El requísits són els següents:

    - La base de dades ha de ser MySQL a la versió 5.7.
    - La aplicació web ha de ser en Python 3.9 utiltizant les següents llibreries:
      - fastapi==0.95.1
      - uvicorn==0.22.0
      - SQLAlchemy==2.0.21
      - pymysql==1.0.3
      - cryptography==35.0.0

    On `main.py` és el següent:

    ```python
    from fastapi import FastAPI, HTTPException, Depends
    from sqlalchemy.orm import Session
    import models, schemas, database

    # Crear l'aplicació FastAPI
    app = FastAPI()

    # Crear les taules de la base de dades
    models.Base.metadata.create_all(bind=database.engine)

    # Ruta inicial
    @app.get("/")
    def read_root():
        return {"message": "Hello World"}

    # Ruta per obtenir un element
    @app.get("/items/{item_id}", response_model=schemas.Item)
    def read_item(item_id: int, db: Session = Depends(database.get_db)):
        item = db.query(models.Item).filter(models.Item.id == item_id).first()
        if item is None:
            raise HTTPException(status_code=404, detail="Item not found")
        return item

    # Ruta per crear un nou element
    @app.post("/items/", response_model=schemas.Item)
    def create_item(item: schemas.ItemCreate, db: Session = Depends(database.get_db)):
        db_item = models.Item(**item.dict())
        db.add(db_item)
        db.commit()
        db.refresh(db_item)
        return db_item
    ```

    i models.py:

    ```python
    from sqlalchemy import Column, Integer, String, Float
    from sqlalchemy.ext.declarative import declarative_base

    Base = declarative_base()

    class Item(Base):
        __tablename__ = "items"
        id = Column(Integer, primary_key=True, index=True)
        name = Column(String(50), index=True)
        description = Column(String(255))
        price = Column(Float)
        tax = Column(Float, nullable=True)
    ```

    i schemas.py:

    ```python
    from pydantic import BaseModel

    class ItemBase(BaseModel):
        name: str
        description: str
        price: float
        tax: float = None

    class ItemCreate(ItemBase):
        pass

    class Item(ItemBase):
        id: int

        class Config:
            orm_mode = True
    ```

    i database.py:

    ```python
    from sqlalchemy import create_engine
    from sqlalchemy.orm import sessionmaker

    SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:password@db:3306/testdb"

    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    def get_db():
        db = SessionLocal()
        try:
            yield db
        finally:
            db.close()
    ```

    i init.sql:

    ```sql
    CREATE DATABASE IF NOT EXISTS testdb;
    USE testdb;
    CREATE TABLE IF NOT EXISTS items (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        description TEXT,
        price FLOAT NOT NULL,
        tax FLOAT
    );
    ```
