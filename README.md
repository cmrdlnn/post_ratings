# Post ratings

## Development environment

To deploy for development you need to install a Vagrant version >= 2.1.2 and run the following command in your terminal:

```sh
vagrant up && vagrant ssh
```

This command will install the Ubuntu 18.04 LTS «Bionic Beaver» image, then configure the virtual machine based on it and install inside its ruby version manager `rbenv v1.1.2`, `Ruby v2.6.3` and `PostgeSQL 11` with development and test databases.

Test database will have the name `post_ratings_test` and development database will have the name `post_ratings`. The owner of these databases will have username `user_post_ratings` and password `123456` and superuser privileges.

After the setup you need to run the database migration to create the necessary tables. To run the migration use the following command:

```sh
make migrate
```

If you need to downgrade the migration use the following command:

```sh
make rollback
```

## Application launch

To run the application use command:

```sh
make run
```

## Tests

To run tests use the following command:

```sh
make test
```

## Debug

To start the debugging console with the loaded application code, use the following command:

```sh
make debug
```
