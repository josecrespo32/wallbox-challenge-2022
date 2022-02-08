# Demo app for wallbox-challenge-2022

A simple demo API Rest for managing users and chargers.

## Setup environment
The only required environment setup is to set the ```TOKEN_SECRET``` environment variable. For simplicity reasons you may create a .env file that contains the variable definition:

```bash
TOKEN_SECRET=myAppSuperSecret!
```

## Run app with npm
You need the following software:
 - node (preferred LTS version)
 - npm

Install depencies:
```bash
npm install
```
And just start the application with npm:
```bash
npm start
```
or
```bash
npm run swagger-autogen
```

## Run app with docker

You need Docker installed in your system.

Then build the docker image:

```bash
docker build -t wallbox-challenge .
```

And run it with docker run:

```bash
docker run -p 3000:3000 wallbox-challenge
```

# Getting started

## Check API Rest health

Once the application is running you may perform GET http://localhost:3000/ to check if API Rest is up and running.

## Data

This demo doesn't uses any database for data persistence. That means all data is volatile and will be erased if the service is stopped or restarted.

The 'database' is convenient initialized at every launch with a user of each role:
 * user@wallbox.com:user1234
 * admin@wallbox.com:admin1234

There also exist two convenient 'database' methods for clearing 'Users' and 'Chargers' collections.

## Endpoints documentation

Once the application is running, Swagger documentation is exposed at http://localhost:3000/api-docs

## Resources
* Users: Models actors of the system. Two different roles: admins and users. 
  * Admins models system operators for registering users and chargers.
  * Users models the charger clients that need to use charger services.
* Chargers: Models a charger entity.

## Authorization

All endpoints except GET / and POST /signin are authenticated endpoints by Bearer authorization header. For generating the token just perform POST /signin with a valid and existent user.
There exists 2 different roles: 
* admin: They administer the app status and CRUD resources, also links users to chargers
* user: Mostly for getting information and edit its own profile/resources

This app follows 2 diferent authorization rules:
* User over user: When an user account (user or admin) tries to access to user resources
* User over charger: When an user account (user or admin) tries to access to charger resources

User over user:
- Admin over himself is ok but Admin over other admin is not possible
- Admin over users is ok
- User over himself is ok but User over other user is not possible
- User over admins is not possible

User over charger:
- Admin over any charger is ok
- User over any charger (unliked from him) is not possible
- User over owned charger (linked to him) is ok

## Link/unlink chargers to users
Endpoint for link users and chargers:
```POST /chargers/:uidcharger/users/:uiduser```
Endpoint for unlink users and chargers:
```DELETE /chargers/:uidcharger/users/:uiduser```

## Explore!
That's all about this demo API rest application.
Take in cosideration this demo is in development and may contain bugs and defects! If so, would be super nice to report it as an issue and help to improve this app demo.
It's also possible that exists some feature that is not described in this document. It will be included in a next future!
