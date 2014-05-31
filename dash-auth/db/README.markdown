Adding a Migration
========================================================================

To add a migration create a file in the migrations folder, extend the 
Migration class and implement an `up` and `down` function that creates
the changes to go "up" a version and to revert "down" a version. 

The implemented function **MUST** return a boolean True or False. Return 
False if something goes horribly wrong, and True if the up or down 
action is successful. This is how the code that keeps track of whether 
or not your database is up to date determines it's own tracking updates.

Returning the result of a mysql query is typically the best way to go
and will evaluate correctly.

Once you've created the up and down functions within a class extending
the base Migration class, you'll need to add it to the migrations array.
Within the UserMigration, the code to do this is as follows:

    $mName = "UserMigration";
    $m = new UserMigration($mName, Migration::isRan($mName, $connection), $connection);
    $migrations[] = $m;

In order for your migration to be detected correctly by the calling 
script, you'll need to give a _unique_ name to the migration and then
call the correct class. So for a "Simple-Auth Migration" that would create a 
migration having to do with the structure of the Simple Auth table you might
have the following code:

    $mName = "AddIdFieldToSimpleAuth";
    $m = new AddFieldToSimpleAuthMigration($mName, Migration::isRan($mName, $connection), $connection);
    $migrations[] = $m;

It's as easy as changing two parts and you're all set. Refer to the 
`UserMigration.php` migration if you need a reference for what you're
php script should look like.


