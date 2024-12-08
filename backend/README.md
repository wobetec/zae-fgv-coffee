# Backend

## Execution

### Locally

Go to the backend directory

    cd backend

Using python 3.12.4. Install the required packages

    pip install -r requirements.txt

Setup the database

    python manage.py makemigrations
    python manage.py migrate

Create a superuser (is required to access the admin panel)

    python manage.py createsuperuser

Populate the local database with the initial data

    python manage.py populate

Run the server

    python manage.py runserver

#### Running the tests
To run the tests use:

    python manage.py test ./app/tests

### Database

By default, the database is SQLite in local execution. In production we are using MySQL hosted on Google Cloud. For security reasons, the database credentials are not available in this repository.
