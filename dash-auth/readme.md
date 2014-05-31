Simple Auth Setup
------------------------------------------------------------------------

Apache Setup

To have nice url's for the API you can use this to enable .htaccess

    <Directory /path/to/your/folder >
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            allow from all
    </Directory>

For Database you should a simple-auth database and user (see conf.php) and then
go to `db/migrate.php` and run the migrations to retrieve the database migration
to add the Users table.