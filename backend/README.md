# Django Backend

## Installation
Using python 3.12.4. Install the required packages using the following command:

    pip install -r requirements.txt

## Database setup
To setup the database, use the following command:

    python manage.py migrate

## Creating a superuser
To create a superuser, use the following command:

    python manage.py createsuperuser

## Populating the database
To populate the database with the initial data, use the following command:

    python manage.py populate

## Running the server
To run the server, use the following command:

    python manage.py runserver

## Running the tests
To run the tests, use the following command:

    python manage.py test ./app/tests
