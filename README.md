# MSSQL-PHP-Dockerfile
A sample docker file that builds a PHP/Apache environment with MSSQL support

### Background
I needed a reliable way to use Laravel/PHP with MSSQL server out in Microsoft Azure.

### SQL Specific config:

This Dockerfile builds a Docker image starting with a base php/apache image, then layers on the prerequisites and then the sql driver.

### application specific config:

Towards the end of the docker file you'll see where I copied in a PHP.ini and apache vhost file.

After that I copy in my whole laravel project, and the .dockerignore file keeps the hidden laravel .env file from being included

Finally I set some permissions on a few folders.

Depending on your project you can remove or alter these lines as needed.
